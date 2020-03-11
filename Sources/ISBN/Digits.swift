//
//  Digit.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

extension Int {
    var digits: [Int] {
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
    private let digits: [Digit]
    
    var count: Int {
        return digits.count
    }
    
    var integers: [Int] {
        digits.map { $0.rawValue }
    }
    
    var string: String {
        String(digits.map { $0.character })
        // TODO: Consider just using String
        // rather than converting to Character.
    }
    
    var singleInteger: Int {
        guard let integer = Int(string) else {
            fatalError()
        }
        return integer
    }
}
// TODO: Consider making these methods
// extensions to [Digit] instead.
