import XCTest
@testable import PubNubSwift

class PubNubSwiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let client = PubNub(publishKey: nil, subscribeKey: nil)
        
        client.googleTest()
    }
    
    func testPublish() {
        
        let client = PubNub(publishKey: publishKey, subscribeKey: subscribeKey)
        
        XCTAssertEqual(client.publish(channel: "holla", json: "{\"Meow\" : \"Hello\"}"), PublishResponse.success)
    }


    static var allTests : [(String, (PubNubSwiftTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
