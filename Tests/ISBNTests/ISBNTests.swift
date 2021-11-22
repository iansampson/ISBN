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
    
    func testGermanISBN10() throws {
        // When
        let isbn = try ISBN("3484701536")
        
        // Then
        XCTAssertEqual(isbn.hyphenated(format: .isbn13), "978-3-484-70153-3")
        XCTAssertEqual(isbn.hyphenated(format: .isbn10), "3-484-70153-6")
    }
    
    func testGermanISBN13() throws {
        // When
        let isbn = try ISBN("978-3484701533")
        
        // Then
        XCTAssertEqual(isbn.hyphenated(format: .isbn13), "978-3-484-70153-3")
    }
}

// TODO: Allow returning a hyphenated ISBN10.
// TODO: Return correct checksum digit.
// TODO: Consider returning nil 
// TODO: Handle pre-hyphenated ISBN strings
// TODO: Store registration group agency with ISBN.
// TODO: Avoid re-loading range map every time we parse
