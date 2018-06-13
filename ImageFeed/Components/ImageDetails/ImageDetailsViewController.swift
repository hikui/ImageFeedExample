//
//  ImageDetailsViewController.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var imageFeedVM: ImageFeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = imageFeedVM.imageFeed.title
        imageView.image = imageFeedVM.image
        descriptionLabel.text = imageFeedVM.imageFeed.description
    }
}
