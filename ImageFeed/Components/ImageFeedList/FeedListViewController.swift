//
//  FeedListViewController.swift
//  ImageFeed
//
//  Created by Henry Miao on 12/6/18.
//  Copyright © 2018 Henry Miao. All rights reserved.
//

import UIKit

class FeedListViewController: UIViewController {

    var feedList = [ImageFeed]() {
        didSet {
            reloadCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestFeedList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Mark: - Actions
extension FeedListViewController {
    func displayError(error: Error) {
        
    }
    
    func reloadCollectionView() {
        
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
                strongSelf.feedList = try ResponseParser.parseFeedList(data: data, response: response, error: error)
            } catch {
                strongSelf.displayError(error: error)
            }
        }
        task.resume()
    }
}
