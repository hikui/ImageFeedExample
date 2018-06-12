//
//  ResponseParser.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

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
        
        // Be careful about the encoding
        guard let iso = String(data: data, encoding: .isoLatin1), let utf8Data = iso.data(using: .utf8) else {
            throw NetworkError.invalidBody
        }
        
        guard let jsonWrapper = try JSONSerialization.jsonObject(with: utf8Data, options: .allowFragments) as? [String: Any],
            let dictArray = jsonWrapper["rows"] as? [[String: Any]] else {
            throw NetworkError.invalidBody
        }
        
        return dictArray.map { (dict) -> ImageFeed in
            return ImageFeed(dict: dict)
        }
    }
    
    static func parseImageBody(data: Data?, response: URLResponse?, error: Error?) throws -> UIImage {
        try checkResponse(data: data, response: response, error: error)
        
        guard let data = data else {
            throw NetworkError.emptyBody
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidBody
        }
        
        return image
    }
}
