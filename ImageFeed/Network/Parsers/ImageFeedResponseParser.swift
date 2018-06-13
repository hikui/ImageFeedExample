//
//  ImageFeedResponseParser.swift
//  ImageFeed
//
//  Created by Henry Miao on 13/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import Foundation

class ImageFeedResponseParser: BaseResponseParser<[ImageFeed]> {
    
    func parseWithThrow() throws {
        try checkResponse()
        
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
        
        self.result = dictArray.map { (dict) -> ImageFeed in
            return ImageFeed(dict: dict)
        }
    }
    
    override func parse() {
        do {
            try parseWithThrow()
        } catch {
            self.error = error
        }
    }
}
