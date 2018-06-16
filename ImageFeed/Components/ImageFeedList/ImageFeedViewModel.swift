//
//  ImageFeedViewModel.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

/// Delegate used to notify the change of VM's state
protocol ImageFeedViewModelDelegate: class {
    func viewModelDidChangeStatus(_ viewModel: ImageFeedViewModel)
}

/// ViewModel for a single Image
class ImageFeedViewModel {
    
    enum LoadingStatus {
        case notStarted
        case loading
        case succeeded
        case failed
    }
    
    var imageFeed: ImageFeed
    var loadingStatus = LoadingStatus.notStarted {
        didSet {
            self.delegate?.viewModelDidChangeStatus(self)
        }
    }
    
    // The loaded image will go here
    var image: UIImage?
    
    weak var delegate: ImageFeedViewModelDelegate?
    
    private var loadingTask: URLSessionTask?
    
    init(imageFeed: ImageFeed) {
        self.imageFeed = imageFeed
    }
    
    func loadImage() {
        if loadingStatus != .notStarted {
            // Skip if it's alrady loading
            return
        }
        
        loadingStatus = .loading
        guard let urlString = imageFeed.imageHref, let url = URL(string: urlString) else {
            loadingStatus = .failed
            return
        }
        
        let globalURLSession = (UIApplication.shared.delegate as! AppDelegate).globalURLSession
        
        self.loadingTask = RequestFactory.imageBodyRequestTask(session: globalURLSession, imageURL: url, then: { [weak self] (parser) in
            guard let strongSelf = self else { return }
            if parser.error != nil {
               strongSelf.loadingStatus = .failed
            } else {
                strongSelf.image = parser.result
                strongSelf.loadingStatus = .succeeded
            }
        })
        
        self.loadingTask?.resume()
    }
    
    func cancelLoading() {
        loadingTask?.cancel()
    }
}
