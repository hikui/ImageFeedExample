//
//  RequestFactory.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import Foundation

/// RequestFactory creates URLSessionTasks
class RequestFactory {
    static func commonRequestTaskWithParser<ParserType: ResponseParser>(session: URLSession,
                                                                        url: URL,
                                                                        then:@escaping ((ParserType) -> Void)) -> URLSessionTask {
        return session.dataTask(with: url, completionHandler: { (data, response, error) in
            let parser = ParserType.init(data: data, response: response, error: error)
            parser.parse()
            DispatchQueue.main.async {
                // Ensure that callback is on main thread
                then(parser)
            }
        })
    }
    
    /// Get feed list
    ///
    /// - Parameters:
    ///   - session: URLSession object
    ///   - then: callback with specified parser as parameter
    /// - Returns: URLSessionTask
    static func feedListRequestTask(session: URLSession,
                                    then:@escaping ((ImageFeedResponseParser) -> Void)) -> URLSessionTask {
        return commonRequestTaskWithParser(session: session, url: Constants.Networking.feedURL, then: then)
    }
    
    /// Download an image
    ///
    /// - Parameters:
    ///   - session: URLSession object
    ///   - imageURL: image url to download
    ///   - then: callback
    /// - Returns: URLSessionTask
    static func imageBodyRequestTask(session: URLSession,
                                     imageURL: URL,
                                     then:@escaping ((ImageBodyResponseParser) -> Void)) -> URLSessionTask {
        return commonRequestTaskWithParser(session: session, url: imageURL, then: then)
    }
}
