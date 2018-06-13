//
//  FeedListViewController.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

class FeedListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl = UIRefreshControl()
    
    var feedList = [ImageFeedViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        requestFeedList()
        LoadingMaskView.showIn(view: self.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageStatusChangeNotification(_:)), name: Constants.NotificationName.imageLoaded, object: nil)
    }
    
    func setupViews() {
        // Customize collection view
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.insertSubview(refreshControl, at: 0)
        }
        refreshControl.addTarget(self, action: #selector(refreshControlStartRefreshing), for: .valueChanged)
    }
}

// Mark: - Actions
extension FeedListViewController {
    func displayError(error: Error) {
        
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
        if feedList.count == 0 {
            let label = UILabel()
            label.text = "No feed available"
            label.textAlignment = .center
            collectionView.backgroundView = label
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    @objc func imageStatusChangeNotification(_ notification: Notification) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func refreshControlStartRefreshing() {
        requestFeedList()
    }
}

// MARK: - Request
extension FeedListViewController {
    func requestFeedList() {
        // This singleton is inevitable
        let globalURLSession = (UIApplication.shared.delegate as! AppDelegate).globalURLSession
        let task = RequestFactory.feedListRequestTask(session: globalURLSession) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                do {
                    let feeds = try ResponseParser.parseFeedList(data: data, response: response, error: error)
                    strongSelf.feedList = feeds.map { ImageFeedViewModel(imageFeed: $0) }
                    strongSelf.feedListLoaded()
                } catch {
                    strongSelf.displayError(error: error)
                }
            }
        }
        task.resume()
    }
    
    func feedListLoaded() {
        reloadCollectionView()
        LoadingMaskView.removeFrom(view: self.view)
        refreshControl.endRefreshing()
    }
}

extension FeedListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageFeedCell.defaultIdentifier, for: indexPath)
        
        let idx = indexPath.item
        
        if let imageFeedCell = cell as? ImageFeedCell {
            imageFeedCell.containerWidth = collectionView.frame.size.width
            imageFeedCell.bind(viewModel: feedList[idx])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let idx = indexPath.item
        feedList[idx].loadImage()
    }
}
