//
//  IFNetworkErrors.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case failureStatusCode(status: Int, data: Data?)
    case emptyBody
    case invalidBody
}
