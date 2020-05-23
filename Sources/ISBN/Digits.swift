//
//  Digit.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

extension Int {
    var digits: [Int] {
        // TODO: Consider returning Digits instead.
        String(self).map {
            guard let integer = $0.wholeNumberValue else {
                fatalError()
            }
            return integer
        }
    }
}
// TODO: Consider returning Digit so that Int
// is guaranteed to be a single digit.

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

extension Digit {
    var character: Character {
        Character(String(rawValue))
        // TODO: Use a more efficient method.
    }
}

struct Digits {
    let digits: [Digit]
}

extension Digits {
    init<S: StringProtocol>(_ string: S) throws {
        digits = try string.map {
            guard
                let value = $0.wholeNumberValue,
                let digit = Digit(rawValue: value)
            else {
                throw ISBN.Error.invalidCharacter
            }
            return digit
        }
    }
    
    init(_ integer: Int) throws {
        try self.init(integer.description)
    }
}

extension Collection where Element == Digit {
    var string: String {
        String(map { $0.character })
        // TODO: Consider just using String
        // rather than converting to Character.
    }
    
    var singleInteger: Int {
        guard let integer = Int(string) else {
            fatalError()
        }
        return integer
    }
    
    var integers: [Int] {
        map { $0.rawValue }
    }
}

// TODO: Consider making these methods
// extensions to [Digit] instead.

extension Digits: Collection {
    var startIndex: Int {
        digits.startIndex
    }
    
    var endIndex: Int {
        digits.endIndex
    }
    
    func index(after i: Int) -> Int {
        digits.index(after: i)
    }
    
    subscript(position: Int) -> Digit {
        digits[position]
    }
}

extension Int {
    // TODO: Find a more efficient implementation.
    var integers: [Int] {
        description.map {
            $0.wholeNumberValue!
        }
    }
    // TODO: Redundant. See .digits.
}
