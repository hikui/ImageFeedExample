//
//  Parser.swift
//  ImageFeed
//
//  Created by Henry Miao on 13/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import Foundation

/// Parser protocol used to generalise parse operations
/// @See RequestFactory for usage
protocol ResponseParser {
    associatedtype ResultType
    
    var result: ResultType? { get }
    var response: URLResponse? { get set }
    var data: Data? { get set }
    var error: Error? { get set }
    
    init(data: Data?, response: URLResponse?, error: Error?)
    
    func parse()
}

extension ResponseParser {
    
    /// Check if the request has failed
    ///
    /// - Throws: system network error or customized NetworkError
    func checkResponse() throws {
        if let error = error {
            throw error
        }
        
        if let response = response as? HTTPURLResponse {
            // We need to check the status code
            if response.statusCode >= 400 {
                throw NetworkError.failureStatusCode(status: response.statusCode, data: data)
            }
        }
    }
}

/// Base class that implements the basic instance valuables and the initializer
class BaseResponseParser<T>: ResponseParser {
    var result: T?
    var response: URLResponse?
    var data: Data?
    var error: Error?
    
    required init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func parse() {
        // Implemented in sub classes
    }
}
