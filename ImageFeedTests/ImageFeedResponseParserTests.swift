//
//  ImageFeedResponseParserTests.swift
//  ImageFeedTests
//
//  Created by Henry Miao on 13/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import XCTest
@testable import ImageFeed

class ImageFeedResponseParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInvalidJSONData() {
        let jsonString = "{ abc: def"
        let data = jsonString.data(using: .isoLatin1)
        let parser = ImageFeedResponseParser(data: data, response: nil, error: nil)
        parser.parse()
        XCTAssertNotNil(parser.error)
    }
    
    func testInvalidFormatData() {
        var jsonString = "{\"Exception\": \"This json doesn't have 'row'\"}"
        var data = jsonString.data(using: .isoLatin1)
        var parser = ImageFeedResponseParser(data: data, response: nil, error: nil)
        parser.parse()
        switch parser.error! {
        case NetworkError.invalidBody:
            ()
        default:
            XCTAssertFalse(true, "invalidBody should be thrown")
        }
        
        jsonString = "{\"row\": [1, 2, 3]}"
        data = jsonString.data(using: .isoLatin1)
        parser = ImageFeedResponseParser(data: data, response: nil, error: nil)
        parser.parse()
        switch parser.error! {
        case NetworkError.invalidBody:
            ()
        default:
            XCTAssertFalse(true, "invalidBody should be thrown")
        }
    }
}
