//
//  Error.swift
//  
//
//  Created by Ian Sampson on 2019-09-12.
//

extension ISBN {
    enum Error: Swift.Error {
        case invalidHyphenation
        case invalidCharacter
        case invalidCountryCode
        case invalidSubstring(String)
        case invalidChecksum(stored: Int, generated: Int)
        case invalidLength(Int)
        case missingChecksum
        case emptyString
        case invalidRange
        case expectedEmptyStringAfterISBN
    }
}

extension Checksum.Digit {
    enum Error: Swift.Error {
        case invalidDigit
    }
}

// TODO: Consider merging witht ISBN.Error.
// TODO: Record *where* the error occured.
