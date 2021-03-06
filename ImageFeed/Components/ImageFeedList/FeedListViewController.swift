//
//  FeedListViewController.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

/// View controller that displays the feed list
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Fixed crash on iOS 8
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupViews() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.insertSubview(refreshControl, at: 0)
        }
        refreshControl.addTarget(self, action: #selector(refreshControlStartRefreshing), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.pushImageDetailsSegue {
            guard let targetViewController = segue.destination as? ImageDetailsViewController,
                let cell = sender as? ImageFeedCell else { return }
            targetViewController.imageFeedVM = cell.viewModel
        }
    }
    
    deinit {
        // Cancel loading when the controller deallocates
        feedList.forEach { $0.cancelLoading() }
    }
}

// Mark: - Actions
extension FeedListViewController {
    func displayError(error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        LoadingMaskView.removeFrom(view: self.view)
        refreshControl.endRefreshing()
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
        guard let sender = notification.object as? ImageFeedCell else { return }
        if sender.viewModel.loadingStatus == .succeeded {
            // Invalidate layout when a picture is successfully loaded
            collectionView.collectionViewLayout.invalidateLayout()
        }
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
        
        let task = RequestFactory.feedListRequestTask(session: globalURLSession) { [weak self] (parser) in
            guard let strongSelf = self else { return }
            if let error = parser.error {
                strongSelf.displayError(error: error)
            } else if let feeds = parser.result {
                strongSelf.feedList = feeds.map { ImageFeedViewModel(imageFeed: $0) }
                strongSelf.feedListLoaded()
            } else {
                // Won't reach here
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

// MARK: - CollectionView delegates and data source
extension FeedListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Use the classic way to adapt iOS 8
        let idx = indexPath.item
        let vm = feedList[idx]
        let size = ImageFeedCell.estimatedSize(forModel: vm, containerWidth: collectionView.frame.width)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // The image is loaded only when the associated cell is about to display
        let idx = indexPath.item
        feedList[idx].loadImage()
    }
}
