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
    
    init(dict: [String: Any]) {
        self.title = dict["title"] as? String ?? nil
        self.description = dict["description"] as? String ?? nil
        self.imageHref = dict["imageHref"] as? String ?? nil
        
        if title == nil && description == nil && imageHref == nil {
            print("Invalid feed")
        }
    }
}
