//
//  LoadingMaskView.swift
//  ImageFeed
//
//  Created by Henry Miao on 13/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

/// A helper view that masks a view when loading is taking place
class LoadingMaskView: UIView {
    var activityIndicator: UIActivityIndicatorView
    
    override init(frame: CGRect) {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Make it center
        NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        activityIndicator.startAnimating()
    }
    
    /// Display a LoadingMaskView on a view
    ///
    /// - Parameter view: the view in which the mask will be displayed
    class func showIn(view: UIView) {
        let loadingView = LoadingMaskView(frame: view.bounds)
        view.addSubview(loadingView)
    }
    
    /// Remove all mask views from a view
    ///
    /// - Parameter view: the parent view
    class func removeFrom(view: UIView) {
        for subview in view.subviews {
            if subview is LoadingMaskView {
                subview.removeFromSuperview()
            }
        }
    }
}
