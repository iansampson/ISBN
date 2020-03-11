//
//  ISBN.swift
//
//
//  Created by Ian Sampson on 2019-09-12.
//

// TODO: Allow unhyphenated ISBNs.
// TODO: Allow method for comparing ISBN10 and ISBN13
//       (which is already possible with Equatable).
// TODO: Implement Codable (by encoding the ISBN
//       to a string – with hyphenation).
// TODO: Add .string func (with or without hyphenation).

struct ISBN: Equatable {
    let countryCode: CountryCode
    let registrationGroup: Int
    let registrant: Int
    let publication: Int
    
    enum Format {
        case isbn10
        case isbn13
    }
    
    init(string: String) throws {
        // TODO: Consider renaming to init(_ string: String).
        
        // Split string by hyphens.
        let substrings = string.split { $0.isHyphen }
        
        // Retrieve registration elements
        // (group, registrant, and publication).
        let elementsBeforeChecksum: [Int] = try substrings
            .dropLast()
            .map {
                guard let integer = Int($0) else {
                    throw Error.invalidCharacter
                }
                return integer
            }
        
        // Retrieve last character for checksum.
        guard let lastSubstring = substrings.last else {
            throw Error.emptyString
        }
        let lastString = String(lastSubstring)
        guard lastSubstring.count == 1 else {
            throw Error.invalidSubstring(lastString)
        }
        let lastCharacter = Character(lastString)
        // TODO: Consider abstracting these two into a struct.
        
        // Switch on ISBN format.
        switch elementsBeforeChecksum.count {
        // TODO: Check total length of string.
        // TODO: Initialize a format and switch on that.
        case 3:
            try self.init(
                countryCode: .bookland,
                registrationElements: elementsBeforeChecksum
            )
            try validateChecksum(lastCharacter, format: .isbn10)
            
        case 4:
            try self.init(
                countryCode: try CountryCode(elementsBeforeChecksum[0]),
                registrationElements: elementsBeforeChecksum.dropFirst()
            )
            try validateChecksum(lastCharacter, format: .isbn13)
        // TODO: Use guard instead of force unwrapping.
            
        default:
            throw Error.invalidHyphenation
            // TODO: Distinguish between invalid hyphenation
            // and an empty string (or an unhyphenated string).
        }
    }
    
    private func validateChecksum(_ character: Character, format: Format) throws {
        let checksumToValidate = try Checksum(character, format: format)
        let generatedChecksum = self.checksum(format: format)
        guard checksumToValidate == generatedChecksum else {
            throw Error.invalidChecksum(
                stored: checksumToValidate.digit.rawValue,
                generated: generatedChecksum.digit.rawValue
            )
        }
    }
    
    private init<S>(countryCode: CountryCode, registrationElements: S) throws
        where S : Collection, S.Element == Int, S.Index == Int {
            let registrationLength = registrationElements
                .flatMap { $0.digits }
                .count
            guard registrationLength == 9 else {
                throw Error.invalidLength(registrationLength)
            }
            // TODO: Consider checking the length of the string instead.
            // TODO: Consider using registrationDigits.
            
            self.countryCode = countryCode
            registrationGroup = registrationElements[0]
            registrant = registrationElements[1]
            publication = registrationElements[2]
    }
}
