//
//  ImageFeedViewModel.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

class ImageFeedViewModel {
    
    enum LoadingStatus {
        case notStarted
        case loading
        case succeeded
        case failed
    }
    
    var imageFeed: ImageFeed
    var loadingStatus = LoadingStatus.notStarted
    var image: UIImage?
    
    private var loadingTask: URLSessionTask?
    
    init(imageFeed: ImageFeed) {
        self.imageFeed = imageFeed
    }
    
    func loadImage() {
        loadingStatus = .loading
        guard let urlString = imageFeed.imageHref, let url = URL(string: urlString) else {
            loadingStatus = .failed
            NotificationCenter.default.post(name: Constants.NotificationName.imageLoaded, object: self)
            return
        }
        
        let globalURLSession = (UIApplication.shared.delegate as! AppDelegate).globalURLSession
        self.loadingTask = RequestFactory.imageBodyRequestTask(session: globalURLSession,
                                                               imageURL: url,
                                                               completionHandler: { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            do {
                strongSelf.image = try ResponseParser.parseImageBody(data: data, response: response, error: error)
                strongSelf.loadingStatus = .succeeded
            } catch {
                strongSelf.loadingStatus = .failed
            }
            
            NotificationCenter.default.post(name: Constants.NotificationName.imageLoaded, object: self)
        })
        self.loadingTask?.resume()
    }
    
    func cancelLoading() {
        loadingTask?.cancel()
    }
}

//extension ImageFeedViewModel: Equatable {
//    static func == (lhs: ImageFeedViewModel, rhs: ImageFeedViewModel) -> Bool {
//        
//    }
//}
