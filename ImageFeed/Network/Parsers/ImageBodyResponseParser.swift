//
//  ImageBodyParser.swift
//  ImageFeed
//
//  Created by Henry Miao on 13/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

class ImageBodyResponseParser: BaseResponseParser<UIImage> {
    func parseWithThrow() throws {
        try checkResponse()
        
        guard let data = data else {
            throw NetworkError.emptyBody
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidBody
        }
        
        self.result = image
    }
    
    override func parse() {
        do {
            try parseWithThrow()
        } catch {
            self.error = error
        }
    }
}
