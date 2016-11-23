import XCTest
@testable import PubNubSwift

class PubNubSwiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(PubNubSwift().text, "Hello, World!")
    }


    static var allTests : [(String, (PubNubSwiftTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
