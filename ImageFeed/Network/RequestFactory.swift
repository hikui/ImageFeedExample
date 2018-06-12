//
//  RequestFactory.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import Foundation

class RequestFactory {
    static func feedListRequestTask(session: URLSession,
                                    completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionTask {
        return session.dataTask(with: Constants.Networking.feedURL, completionHandler: completionHandler)
    }
    
    static func imageBodyRequestTask(session: URLSession,
                                     imageURL: URL,
                                     completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionTask {
        return session.dataTask(with: imageURL, completionHandler: completionHandler)
    }
}
