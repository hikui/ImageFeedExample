//
//  ResponseParser.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import Foundation

final class ResponseParser {
    static func checkResponse(data: Data?, response: URLResponse?, error: Error?) throws {
        if let error = error {
            throw error
        }
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode >= 400 {
                throw NetworkError.failureStatusCode(status: response.statusCode, data: data)
            }
        }
    }
    
    static func parseFeedList(data: Data?, response: URLResponse?, error: Error?) throws -> [ImageFeed] {
        try checkResponse(data: data, response: response, error: error)
        
        guard let data = data else {
            throw NetworkError.emptyBody
        }
        
        guard let dictArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: String]] else {
            throw NetworkError.invalidBody
        }
        
        return dictArray.map { (dict) -> ImageFeed in
            return ImageFeed(dict: dict)
        }
    }
}
