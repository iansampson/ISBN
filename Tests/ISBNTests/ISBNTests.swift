import XCTest
@testable import ISBN

final class ISBNTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ISBN().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
