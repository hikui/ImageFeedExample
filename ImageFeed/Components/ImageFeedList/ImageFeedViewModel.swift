//
//  ImageFeedViewModel.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

protocol ImageFeedViewModelDelegate {
    func viewModelDidChangeStatus(_ viewModel: ImageFeedViewModel)
}

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
            DispatchQueue.main.async {
                self.delegate?.viewModelDidChangeStatus(self)
            }
        }
    }
    var image: UIImage?
    
    var delegate: ImageFeedViewModelDelegate?
    
    private var loadingTask: URLSessionTask?
    
    init(imageFeed: ImageFeed) {
        self.imageFeed = imageFeed
    }
    
    func loadImage() {
        if loadingStatus != .notStarted {
            return
        }
        
        loadingStatus = .loading
        guard let urlString = imageFeed.imageHref, let url = URL(string: urlString) else {
            loadingStatus = .failed
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
        })
        self.loadingTask?.resume()
    }
    
    func cancelLoading() {
        loadingTask?.cancel()
    }
}
