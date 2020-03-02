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
    @IBOutlet weak var tableView: UITableView!

    var users: [User] = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    
}

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var loginLabelConstraint: NSLayoutConstraint!
}
