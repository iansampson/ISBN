//
//  ISBN2Tests.swift
//  
//
//  Created by Ian Sampson on 2020-05-22.
//

import XCTest
@testable import ISBN

final class ISBN2Tests: XCTestCase {
    func testDecodeRangeMessage() throws {
        // When
        let container = try RangeMessage.Container()
        
        // Then
        XCTAssertFalse(container.isbnRangeMessage.registrationGroups.group.isEmpty)
        XCTAssertFalse(container.isbnRangeMessage.eanUccPrefixes.eanUcc.isEmpty)
    }
    
    func testParseISBN10() throws {
        // When
        let isbn = try ISBN("3484701536")
        
        // Then
        XCTAssertEqual(isbn.string(format: .isbn13, hyphenated: true),
                       "978-3-484-70153-3")
        XCTAssertEqual(isbn.string(format: .isbn13, hyphenated: false),
                       "9783484701533")
        XCTAssertEqual(isbn.string(format: .isbn10, hyphenated: true),
                       "3-484-70153-6")
        XCTAssertEqual(isbn.string(format: .isbn10, hyphenated: false),
                       "3484701536")
    }
    
    func testParseHyphenatedISBN10() throws {
        // When
        let isbn = try ISBN("3-484-70153-6")
        
        // Then
        XCTAssertEqual(isbn.string(format: .isbn13, hyphenated: true),
                       "978-3-484-70153-3")
        XCTAssertEqual(isbn.string(format: .isbn13, hyphenated: false),
                       "9783484701533")
        XCTAssertEqual(isbn.string(format: .isbn10, hyphenated: true),
                       "3-484-70153-6")
        XCTAssertEqual(isbn.string(format: .isbn10, hyphenated: false),
                       "3484701536")
    }
    
    func testParseISBN13() throws {
        // When
        let isbn = try ISBN("9783484701533")
        
        // Then
        XCTAssertEqual(isbn.string(format: .isbn13, hyphenated: true),
                       "978-3-484-70153-3")
        XCTAssertEqual(isbn.string(format: .isbn13, hyphenated: false),
                       "9783484701533")
    }
    
    // TODO: Rename this test
    func testParseISBN13B() throws {
        // When
        let isbn = try ISBN("978-0-8223-5656-1")
        
        // Then
        XCTAssertEqual(isbn.string, "978-0-8223-5656-1")
    }
    
    func testParseHyphenatedISBN13() throws {
        // When
        let isbn = try ISBN("978-3-484-70153-3")
        
        // Then
        XCTAssertEqual(isbn.string(format: .isbn13, hyphenated: true),
                       "978-3-484-70153-3")
        XCTAssertEqual(isbn.string(format: .isbn13, hyphenated: false),
                       "9783484701533")
    }
    
    func testParseChecksumX() throws {
        // When
        let isbn = try ISBN("3-598-21507-X")
        
        // Then
        XCTAssertEqual(isbn.string(format: .isbn10, hyphenated: true),
                       "3-598-21507-X")
    }
    
    func testDecodeAndEncodeISBN() throws {
        // Given
        let string = "\"978-3-484-70153-3\""
        guard let data = string.data(using: .utf8) else {
            fatalError()
        }
        
        // When
        let isbn = try JSONDecoder().decode(ISBN.self, from: data)
        let encodedISBN = try JSONEncoder().encode(isbn)
        
        // Then
        XCTAssertEqual(isbn.string, "978-3-484-70153-3")
        XCTAssertEqual(encodedISBN, data)
    }
}
// TODO: Consider removing (or ignoring) hyphens
// during parsing (in case they *are* in the wrong place,
// the number itself is still readable)

// Maybe:
// TODO: Store registration group agency with ISBN.
// TODO: Consider returning nil instead of throwing an error

// Testing:
// TODO: Test musicland ISBNs (and make sure they return nil for the ISBN10 string)
// TODO: Test more ISBNs from around the world

// Efficiency:
// TODO: Avoid re-loading range map every time we parse
// TODO: Avoid decoding RangeMessage.Container *twice*
// TODO: Consider using smaller integers for storage
