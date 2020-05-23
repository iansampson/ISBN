//
//  ISBN2Tests.swift
//  
//
//  Created by Ian Sampson on 2020-05-22.
//

import XCTest
@testable import ISBN

final class ISBN2Tests: XCTestCase {
    func testGermanISBN10() {
        let isbn = ISBN2("3484701536")
        XCTAssertNotNil(isbn)
        XCTAssertEqual(isbn?.hyphenated, "978-3-484-70153-3")
        // TODO: Allow returning a hyphenated ISBN10.
        // TODO: Return correct checksum digit.
    }
    
    func testGermanISBN13() {
        let isbn = ISBN2("978-3484701533")
        XCTAssertNotNil(isbn)
    }
}

// 3484701536
// ISBN-13: 978-3484701533
