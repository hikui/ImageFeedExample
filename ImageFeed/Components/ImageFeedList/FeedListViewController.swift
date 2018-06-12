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
    
    var feedList = [ImageFeedViewModel]() {
        didSet {
            reloadCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestFeedList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageStatusChangeNotification(_:)), name: Constants.NotificationName.imageLoaded, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
    }
}

// Mark: - Actions
extension FeedListViewController {
    func displayError(error: Error) {
        
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc func imageStatusChangeNotification(_ notification: Notification) {
        collectionView.reloadData()
    }
}

// MARK: - Request
extension FeedListViewController {
    func requestFeedList() {
        // This singleton is inevitable
        let globalURLSession = (UIApplication.shared.delegate as! AppDelegate).globalURLSession
        let task = RequestFactory.feedListRequestTask(session: globalURLSession) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            do {
                let feeds = try ResponseParser.parseFeedList(data: data, response: response, error: error)
                strongSelf.feedList = feeds.map { ImageFeedViewModel(imageFeed: $0) }
                // Test
                var feed = ImageFeed(dict: [:])
                feed.imageHref = "https://animeblurayuk.files.wordpress.com/2016/04/fate-stay-night-unlimited-blade-works-part1-dvd-screenshot-7.jpg"
                feed.title = "very very long title very very long title very very long title very very long title very very long title very very long title very very long title very very long title very very long title very very long title very very long title very very long title very very long title "
                strongSelf.feedList.append(ImageFeedViewModel(imageFeed: feed))
            } catch {
                strongSelf.displayError(error: error)
            }
        }
        task.resume()
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
