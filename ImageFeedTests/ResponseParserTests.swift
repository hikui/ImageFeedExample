//
//  ResponseParserTests.swift
//  ImageFeedTests
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import XCTest
@testable import ImageFeed

class ResponseParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCheckResponseWithError() {
        let error = NSError(domain: "test", code: 123, userInfo: nil)
        XCTAssertThrowsError(try ResponseParser.checkResponse(data: nil, response: nil, error: error)) { e in
            XCTAssertEqual(e as NSError, error, "Error should be rethrown")
        }
    }
    
    func testCheckResponseWithEmptyData() {
        do {
            try ResponseParser.checkResponse(data: nil, response: HTTPURLResponse(url: Constants.Networking.feedURL, statusCode: 200, httpVersion: "1.1", headerFields: nil), error: nil)
        } catch {
            XCTAssertFalse(true, "Empty data should pass the response check")
        }
    }
    
    func testCheckResponseWithFailureStatusCode() {
        let response = HTTPURLResponse(url: Constants.Networking.feedURL, statusCode: 404, httpVersion: "1.1", headerFields: nil)
        XCTAssertThrowsError(try ResponseParser.checkResponse(data: nil, response: response, error: nil))
    }
}
