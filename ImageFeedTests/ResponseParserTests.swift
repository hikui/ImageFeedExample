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
    
    var dummyParser: BaseResponseParser<Int>!
    
    override func setUp() {
        super.setUp()
        dummyParser = BaseResponseParser<Int>.init(data: nil, response: nil, error: nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCheckResponseWithError() {
        let error = NSError(domain: "test", code: 123, userInfo: nil)
        dummyParser.error = error
        XCTAssertThrowsError(try dummyParser.checkResponse()) { e in
            XCTAssertEqual(e as NSError, error, "Error should be rethrown")
        }
    }
    
    func testCheckResponseWithEmptyData() {
        do {
            dummyParser.response = HTTPURLResponse(url: Constants.Networking.feedURL, statusCode: 200, httpVersion: "1.1", headerFields: nil)
            try dummyParser.checkResponse()
        } catch {
            XCTAssertFalse(true, "Empty data should pass the response check")
        }
    }
    
    func testCheckResponseWithFailureStatusCode() {
        let response = HTTPURLResponse(url: Constants.Networking.feedURL, statusCode: 404, httpVersion: "1.1", headerFields: nil)
        dummyParser.response = response
        XCTAssertThrowsError(try dummyParser.checkResponse())
    }
}
