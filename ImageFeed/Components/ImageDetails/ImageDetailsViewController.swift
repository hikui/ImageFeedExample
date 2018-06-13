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
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var imageFeedVM: ImageFeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = imageFeedVM.imageFeed.title
        imageView.image = imageFeedVM.image
        descriptionTextView.text = imageFeedVM.imageFeed.description
    }
    
    override var traitCollection: UITraitCollection {
        // Override traitCollection for iPad so that the size classes reflects its orientation
        if UIDevice.current.userInterfaceIdiom != .pad {
            return super.traitCollection
        }
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation.isPortrait {
            return UITraitCollection(traitsFrom: [
                    UITraitCollection(horizontalSizeClass: .compact),
                    UITraitCollection(verticalSizeClass: .regular)
                ])
        }
        return super.traitCollection
    }
}
