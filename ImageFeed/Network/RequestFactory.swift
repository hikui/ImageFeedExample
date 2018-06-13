//
//  RequestFactory.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import Foundation

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
    
    static func feedListRequestTask(session: URLSession,
                                    then:@escaping ((ImageFeedResponseParser) -> Void)) -> URLSessionTask {
        return commonRequestTaskWithParser(session: session, url: Constants.Networking.feedURL, then: then)
    }
    
    static func imageBodyRequestTask(session: URLSession,
                                     imageURL: URL,
                                     then:@escaping ((ImageBodyResponseParser) -> Void)) -> URLSessionTask {
        return commonRequestTaskWithParser(session: session, url: imageURL, then: then)
    }
}
