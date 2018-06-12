//
//  RequestFactory.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import Foundation

class RequestFactory {
    static func feedListRequest(session: URLSession) -> URLSessionTask {
        return session.dataTask(with: Constants.Networking.feedURL)
    }
}
