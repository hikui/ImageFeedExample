//
//  ImageDetailsViewController.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

/// The detail view
class ImageDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // The image view model. This must be assigned before the view controller being displayed
    var imageFeedVM: ImageFeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = imageFeedVM.imageFeed.title
        imageView.image = imageFeedVM.image
        descriptionTextView.text = imageFeedVM.imageFeed.description
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // We'll need to trigger image view's layout and calculate the height again as the image has been changed
        self.imageView.invalidateIntrinsicContentSize()
        self.view.setNeedsLayout()
    }
    
    override var traitCollection: UITraitCollection {
        // Override traitCollection for iPad so that the size classes reflects its orientation
        if UIDevice.current.userInterfaceIdiom != .pad {
            return super.traitCollection
        }
        
        // The trait depends on the current orientation
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation.isPortrait {
            return UITraitCollection(traitsFrom: [
                    UITraitCollection(horizontalSizeClass: .compact),
                    UITraitCollection(verticalSizeClass: .regular)
                ])
        } else if orientation.isLandscape {
            return UITraitCollection(traitsFrom: [
                UITraitCollection(horizontalSizeClass: .regular),
                UITraitCollection(verticalSizeClass: .compact)
            ])
        }
        return super.traitCollection
    }
}
