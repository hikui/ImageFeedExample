//
//  ScaledHeightImageView.swift
//  ImageFeed
//
//  Created by Henry Miao on 13/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

/// Subclass of UIImageView that calculates the intrinsicContentSize with respect of image's width/height ratio
class ScaledHeightImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        guard let image = self.image else {
            return CGSize(width: self.frame.width, height: self.frame.width)
        }

        let ratio = image.size.height / image.size.width
        let scaledHeight = ceil(self.frame.width * ratio)
        return CGSize(width: self.frame.width, height: scaledHeight)
    }
}
