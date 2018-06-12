//
//  ImageFeed.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

struct ImageFeed {
    var title: String?
    var description: String?
    var imageHref: String?
    
    init(dict: [String: String]) {
        self.title = dict["title"]
        self.description = dict["description"]
        self.imageHref = dict["imageHref"]
        
        if title == nil && description == nil && imageHref == nil {
            print("Invalid feed")
        }
    }
}
