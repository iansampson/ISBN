import XCTest
@testable import ISBN

final class ISBNTests: XCTestCase {
    

    // MARK: - Hyphenated ISBN10
    
    func testValidISBN() {
        XCTAssertNoThrow(try ISBN(string: "3-598-21508-8"))
    }
    
    func testValidChecksumX() {
        XCTAssertNoThrow(try ISBN(string: "3-598-21507-X"))
    }
    
    func testInvalidChecksum() {
        XCTAssertThrowsError(try ISBN(string: "3-598-21508-9"))
    }
    
    func testInvalidChecksumCharacter() {
        XCTAssertThrowsError(try ISBN(string: "3-598-21507-A"))
    }
    
    func testInvalidCharacter() {
         XCTAssertThrowsError(try ISBN(string: "3-598-P1581-X"))
    }
    
    func testInvalidX() {
        XCTAssertThrowsError(try ISBN(string: "3-598-2X507-9"))
    }
    
    func testISBNWithoutChecksum() {
        XCTAssertThrowsError(try ISBN(string: "3-598-21507"))
    }
    
    func testChecksumXUsedAsZero() {
        XCTAssertThrowsError(try ISBN(string: "3-598-21515-X"))
    }
    
    
    // MARK: - Unhyphenated ISBN10
    
    func testValidUnhyphenatedISBN() {
        XCTAssertNoThrow(try ISBN(string: "3598215088"))
    }

    func testValidUnhyphenatedISBNWithChecksumX() {
        XCTAssertNoThrow(try ISBN(string: "359821507"))
    }
        
    func testTooLongISBN() {
        XCTAssertThrowsError(try ISBN(string: "3598215078X"))
    }
    
    func testTooShortISBN() {
        XCTAssertThrowsError(try ISBN(string: "00"))
    }
    
    func testEmptyISBN() {
        XCTAssertThrowsError(try ISBN(string: ""))
    }
    
    func testInvalidNineCharacterISBN() {
        XCTAssertThrowsError(try ISBN(string: "134456729"))
        // TODO: Allow 9-character SBN by prepending zero.
    }
    
    func testInvalidCharacterWithoutHyphens() {
        XCTAssertThrowsError(try ISBN(string: "3132P34035"))
    }
    
    func testTooLongStringContainingValidISBN() {
        XCTAssertThrowsError(try ISBN(string: "98245726788"))
    }
    
    /*func testHyphenation() {
        print("===")
        let isbn = 3598215
        let length = Length.countryCodes[0].rules.filter {
            $0.range.contains(isbn)
        }.first?.length
        print(length)
        let length2 = Length.registrationGroups[0].rules.filter {
            $0.range.contains(isbn)
        }.first?.length
        print(length2)
        print("===")
    }*/
    
    // TODO: Test ISBN13.
    // TODO: Test ISBN properties.
    // TODO: Test different hyphenation patterns.
    // TODO: Test Unicode hyphens.
    // TODO: Test equivalence between ISBN10 and ISBN13.
    
    static var allTests = [
        // TODO: Add tests to allTests.
        ("testValidISBN", testValidISBN),
    ]
}
