//
//  Parser.swift
//  ImageFeed
//
//  Created by Henry Miao on 13/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import Foundation

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
    func checkResponse() throws {
        if let error = error {
            throw error
        }
        
        if let response = response as? HTTPURLResponse {
            if response.statusCode >= 400 {
                throw NetworkError.failureStatusCode(status: response.statusCode, data: data)
            }
        }
    }
}

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
        // Implemented in children classes
    }
}
