//
//  User.swift
//  GithubAllUsers
//
//  Created by Laura on 2020/3/3.
//  Copyright © 2020 Laura. All rights reserved.
//

import Foundation

struct User: Codable {
    let login : String
    let avatar_url : String
    let site_admin : Bool
    let id : Int
    let node_id : String
    let gravatar_id : String
    let url : String
    let html_url : String
    let followers_url : String
    let following_url : String
    let gists_url : String
    let starred_url : String
    let subscriptions_url : String
    let organizations_url : String
    let repos_url : String
    let events_url : String
    let received_events_url : String
    let type : String
}
