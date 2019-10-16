//
//  ViewController.swift
//  swift-starred-repositories
//
//  Created by stella on 12/10/19.
//  Copyright © 2019 stella. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerCell: UITableViewCell {
    @IBOutlet weak var uiLabelRepoOwnerName: UILabel?
    @IBOutlet weak var uiLabelRepoName: UILabel?
    @IBOutlet weak var uiRepoOwnerImage: UIImageView?
    @IBOutlet weak var uiLabelRepoStars: UILabel?
}

class ViewController: UIViewController {
    // pull to refresh
    var refreshControl = UIRefreshControl()
    var isFetching = false

    // outlets
    @IBOutlet weak var uiTableView: UITableView?
    
    var result:[NSDictionary] = []
    var requests: Requests = Requests()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupRefreshControl()
    }
    
    @objc func refresh() {
        makeRequest()
        refreshControl.endRefreshing()
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.uiTableView?.addSubview(refreshControl)
    }
    
    private func setup() {
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.uiTableView?.register(loadingNib, forCellReuseIdentifier: "loadingCell")

        self.uiTableView?.dataSource = self
        self.uiTableView?.delegate = self
        self.uiTableView?.prefetchDataSource = self as? UITableViewDataSourcePrefetching
        self.requests.delegate = self
        makeRequest()
    }
    
    func makeRequest() { requests.makeRequest(fetching: isFetching) }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
//        print("offsetY: \(offsetY) | contentHeight: \(contentHeight)")
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isFetching {
                beginFetch()
            }
        }
    }
    
    func beginFetch() {
        isFetching = true
        uiTableView?.reloadSections(IndexSet(integer: 1), with: .none)
        requests.makeRequest(fetching: isFetching)
        isFetching = false
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return result.count
        } else if section == 1 && isFetching {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
            as? ViewControllerCell else { return UITableViewCell() }
        
        guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
            as? LoadingCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let repo = RepositoryDetails.init(from: result[indexPath.row])
            
            cell.uiLabelRepoName?.text = repo?.repoName
            cell.uiLabelRepoStars?.text = "\(repo?.repoStars ?? 0) stars"
            cell.uiLabelRepoOwnerName?.text = "Owner: \(repo?.repoOwnerName ?? "")"
            
            guard let url = repo?.repoOwnerPicture else { return UITableViewCell() }
            
            let data = try? Data(contentsOf: url)

            if let imageData = data {
                cell.uiRepoOwnerImage?.image = UIImage(data: imageData)
            }

            return cell
        } else {
            loadingCell.uiSpinner?.startAnimating()
            return loadingCell
        }
    }
}

extension ViewController: RequestsDelegate {
    func didReceiveData(requests: Requests, dictionary: [NSDictionary]) {
        result = dictionary
        self.uiTableView?.reloadData()
    }
}
