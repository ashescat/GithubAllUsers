//
//  ViewController.swift
//  GithubAllUsers
//
//  Created by Laura on 2020/3/3.
//  Copyright © 2020 Laura. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!

    var users: [User] = [User]()
    lazy var userService: UserService  = {
        return UserService()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initData()
        // Do any additional setup after loading the view.
    }
    
    func initViews() {
        refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(initData), for: UIControl.Event.valueChanged)
        refreshControl.beginRefreshing()
    }
    
    @objc func initData() {
        userService.downloadFirstBatch { (success, users, error) in
            DispatchQueue.main.async {
                // init data
                self.users = users
                // update ui
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()

                // NOTE: need to discuss with ui designer for better ux when errors encountered
            }
        }
    }
    
    func loadMoreData() {
        userService.downloadMore { (success, users, error) in
            DispatchQueue.main.async {
                // add data
                self.users.append(contentsOf: users)
                // update ui
                self.tableView.reloadData()
                
                // NOTE: need to discuss with ui designer for better ux when errors encountered
            }
        }
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCellId", for: indexPath) as? UserTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        // retrieve user data
        let user = self.users[indexPath.row]
        // update ui
        cell.loginLabel.text = user.login
        cell.avatarImgView.sd_setImage(with: URL(string: user.avatar_url), completed: nil)
        cell.badgeLabel.text = user.site_admin ? "  STAFF  " : ""
        cell.loginLabelConstraint.constant = user.site_admin ? 0 : 40
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // table view reaches last row, go and fetch more data
        if indexPath.row == self.users.count - 1 {
            loadMoreData()
        }
    }
}

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var loginLabelConstraint: NSLayoutConstraint!
}
