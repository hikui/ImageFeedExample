//
//  ImageFeedCell.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

class ImageFeedCell: UICollectionViewCell, ImageFeedViewModelDelegate {
    
    static let defaultIdentifier = "ImageFeedCell"
    static let defaultImageSize = CGSize(width: 170, height: 170)
    static let gapImageView = CGFloat(5)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: ImageFeedViewModel!
    var containerWidth: CGFloat = -1
    
    private var isLayoutUpdated = false
    
    static func estimatedSize(forModel viewModel: ImageFeedViewModel,
                              containerWidth: CGFloat,
                              labelAttributes: [NSAttributedStringKey:Any]?) -> CGSize {
        var estimatedImageSize = ImageFeedCell.defaultImageSize
        if let image = viewModel.image, viewModel.loadingStatus == .succeeded {
            estimatedImageSize = image.size
            if estimatedImageSize.width > containerWidth {
                estimatedImageSize.width = containerWidth
                estimatedImageSize.height = ceil(containerWidth / image.size.width * estimatedImageSize.height)
            }
        }
        
        let gap = gapImageView
        var labelSize = CGSize(width: estimatedImageSize.width, height: 20)
        if let text = viewModel.imageFeed.title {
            let boundingRect = NSString(string: text).boundingRect(with: CGSize(width: estimatedImageSize.width, height: 999), options: .usesLineFragmentOrigin, attributes: labelAttributes, context: nil)
            labelSize.height = ceil(boundingRect.height)
        }
        
        return CGSize(width: estimatedImageSize.width, height: estimatedImageSize.height + gap + labelSize.height)
    }
    
    func bind(viewModel: ImageFeedViewModel) {
        self.viewModel = viewModel
        viewModel.delegate = self
        updateStatus()
        updateImage()
        label.text = viewModel.imageFeed.title
    }
    
    func viewModelDidChangeStatus(_ viewModel: ImageFeedViewModel) {
        if viewModel !== self.viewModel { return }
        updateStatus()
        updateImage()
        NotificationCenter.default.post(name: Constants.NotificationName.imageLoaded, object: self)
    }
    
    func updateStatus() {
        if viewModel.loadingStatus == .loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func updateImage() {
        imageView.image = nil
        isLayoutUpdated = false
        self.backgroundColor = .white
        switch viewModel.loadingStatus {
        case .failed:
            imageView.image = #imageLiteral(resourceName: "failed")
        case .loading:
            self.backgroundColor = .blue
        case .succeeded:
            imageView.image = viewModel.image
        default:
            ()
        }
    }
}
