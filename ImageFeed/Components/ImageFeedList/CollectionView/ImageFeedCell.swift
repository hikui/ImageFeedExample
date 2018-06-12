//
//  ImageFeedCell.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

class ImageFeedCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var viewModel: ImageFeedViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit() {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(imageDidLoad(notification:)),
                         name: Constants.NotificationName.imageLoaded,
                         object: nil)
    }
    
    func bind(viewModel: ImageFeedViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func imageDidLoad(notification: Notification) {
        guard let sender = notification.object as? ImageFeedViewModel else {
            return
        }
        
        if sender !== viewModel {
            return
        }
        
        imageView.image = sender.image
    }
}
