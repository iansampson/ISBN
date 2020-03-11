//
//  Checksum.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

// MARK: - Checksum
struct Checksum: Equatable {
    let digit: Digit
    
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
extension ISBN {
    func checksum(format: Format) -> Checksum {
        switch format {
        case .isbn10:
            return try! Checksum(isbn10Checksum)
        case .isbn13:
            return try! Checksum(isbn13Checksum)
        }
    }
    // TODO: Avoid force unwrapping.
    
    private var isbn10Checksum: Int {
        Checksum.sum(first9Digits: registrationDigits)
    }
    
    private var isbn13Checksum: Int {
        Checksum.sum(first9Digits: countryCode.rawValue.digits + registrationDigits)
    }
    
    private var registrationDigits: [Int] {
        registrationGroup.digits
        + registrant.digits
        + publication.digits
    }
}

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
    
    static func sum(first9Digits digits: [Int]) -> Int {
        guard digits.count == 9 else {
            fatalError()
        }
        
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
    
    static func sum(first12Digits digits: [Int]) -> Int {
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
