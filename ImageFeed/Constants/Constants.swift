//
//  Constants.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import Foundation

struct Constants {
    struct Networking {
        /// URL for picture feed.
        static let feedURL = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
    }
    
    struct NotificationName {
        static let imageLoaded = Notification.Name(rawValue: "imageLoaded")
    }
    
    struct UserInfoKey {
        static let imageLoadingFeedKey = "imageLoadingFeedKey"
    }
    
    struct SegueIdentifier {
        static let pushImageDetailsSegue = "pushImageDetailsSegue"
    }
}
