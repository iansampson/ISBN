//
//  Checksum.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

// MARK: - Checksum

struct Checksum: Equatable {
    let digit: Digit
}

extension Checksum {
    init(_ character: Character, format: ISBN.Format) throws {
        if character == "X" && format == .isbn10 {
            self.digit = .ten
            return
        }
        
        guard let integer = character.wholeNumberValue else {
            throw Checksum.Digit.Error.invalidDigit
        }
        self.digit = try Digit(integer)
    }
    
    fileprivate init(_ integer: Int) throws {
        self.digit = try Digit(integer)
    }
}


// MARK: - ISBN

/*extension ISBN {
    func checksum(format: Format) -> Checksum {
        switch format {
        case .isbn10:
            return try! Checksum(isbn10Checksum)
        case .isbn13:
            return try! Checksum(isbn13Checksum)
        }
    }
    // TODO: Avoid force unwrapping.
    
    /*private var isbn10Checksum: Int {
        Checksum.sum(first9Digits: registrationDigits)
    }
    
    private var isbn13Checksum: Int {
        Checksum.sum(first9Digits: countryCode.rawValue.digits + registrationDigits)
    }*/
    
    private var registrationDigits: [Int] {
        registrationGroup.digits
        + registrant.digits
        + publication.digits
    }
}*/


// MARK: - Calculation

private extension Checksum {
    enum Multiplier: Int {
        case tick = 1
        case tock = 3
        mutating func alternate() {
            switch self {
            case .tick: self = .tock
            case .tock: self = .tick
            }
        }
    }
    
    static func sum<C>(first9Digits digits: C) -> Int where C : Collection, C.Element == Int {
        guard digits.count == 9 else {
            fatalError()
        } // TODO: Consider throwing an error instead.
        
        var sum = 0
        var multiplier = 10
        for digit in digits {
            sum += (digit * multiplier)
            multiplier -= 1
        }
        let remainder = sum % 11
        if remainder == 0 {
            return 0
        }
        else {
            return 11 - remainder
        }
    }
    
    static func sum<C>(first12Digits digits: C) -> Int where C : Collection, C.Element == Int {
        guard digits.count == 12 else {
            fatalError()
        }
        
        var sum = 0
        var multiplier: Multiplier = .tick
        for digit in digits {
            sum += (digit * multiplier.rawValue)
            multiplier.alternate()
        }
        let remainder = sum % 10
        if remainder == 0 { return 0 }
        else { return 10 - remainder }
    }
}


// MARK: - Digit

extension Checksum {
    // TODO: Consider using UInt8.
    // or just a plain enum with a switch to return an Int.
    enum Digit: Int {
        case zero   = 0
        case one    = 1
        case two    = 2
        case three  = 3
        case four   = 4
        case five   = 5
        case six    = 6
        case seven  = 7
        case eight  = 8
        case nine   = 9
        case ten    = 10
    }
    // TODO: Remove and replace with ISBN.Digit.
}

extension Checksum.Digit {
    init(_ integer: Int) throws {
        guard let digit = Checksum.Digit(rawValue: integer) else {
            throw Error.invalidDigit
        }
        self = digit
    }
}


// MARK: - Parsable

extension Checksum: Parsable {
    typealias Input = (digitsBeforeChecksum: [Int], format: ISBN.Format)
    
    static func parse(_ input: State<Input>) throws -> State<Checksum> {
        let integers = input.value.digitsBeforeChecksum
        
        guard let nextDigit = input.stream.first else {
            throw ISBN.Error.missingChecksum
        }
        
        guard let parsedChecksum = nextDigit.wholeNumberValue else {
            // TODO: Check for X.
            throw ISBN.Error.invalidCharacter
        }
        // TODO: Test efficiency. And consider using .wholeNumberValue elsewhere.
        
        let expectedChecksum: Int
        switch input.value.format {
        case .isbn10:
            expectedChecksum = Checksum.sum(first9Digits: integers)
        case .isbn13:
            expectedChecksum = Checksum.sum(first12Digits: integers)
        }
        
        guard parsedChecksum == expectedChecksum else {
            throw ISBN.Error.invalidChecksum(
                stored: parsedChecksum,
                generated: expectedChecksum
            )
            // TODO: Rename to parsed and expected.
        }
        
        return State(
            stream: input.stream.dropFirst(), // TODO: Ensure digits.isEmpty
            value: try Checksum(expectedChecksum)
        )
    }
}

extension Checksum.Digit: CustomStringConvertible {
    var description: String {
        String(rawValue)
    }
}

extension Checksum {
    init<C>(_ digits: C, format: ISBN.Format) throws where C : Collection, C.Element == Int {
        switch format {
        case .isbn10:
            try self.init(
                Checksum.sum(first9Digits: digits)
            )
        case .isbn13:
            try self.init(
                Checksum.sum(first12Digits: digits)
            )
        }
    }
}
