//
//  UserService.swift
//  GithubAllUsers
//
//  Created by Laura on 2020/3/3.
//  Copyright © 2020 Laura. All rights reserved.
//

import Foundation

class UserService {

    var nextIndexLink = ""
    var noMoreData = false
    
    func downloadFirstBatch(complete: @escaping ( _ success: Bool, _ users: [User], _ error: Error? )->() ) {
        if (!noMoreData) {
            DispatchQueue.global().async {
                let firstIndexLink = "https://api.github.com/users?since=0&per_page=20"
                if let url = URL(string: firstIndexLink) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        } else if let response = response as? HTTPURLResponse, let data = data {
                            // find next pagination
                            if let link = response.findLink(relation: "next") {
                                self.nextIndexLink = link.uri
                            }
                            // decode json data
                            let decoder = JSONDecoder()
                            if let userData = try? decoder.decode([User].self, from: data) {
                                complete( true, userData, nil )
                            } else {
                                print("Status code: \(response.statusCode)")
                                complete( false, Array(), nil)
                            }
                        }
                        }.resume()
                } else {
                    print("Invalid URL.")
                }
            }
        }
    }
    
    func downloadMore(complete: @escaping ( _ success: Bool, _ users: [User], _ error: Error? )->() ) {
        if (!noMoreData) {
            DispatchQueue.global().async {
                if let url = URL(string: self.nextIndexLink) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        } else if let response = response as? HTTPURLResponse, let data = data {
                            // find next pagination
                            if let link = response.findLink(relation: "next") {
                                self.nextIndexLink = link.uri
                            } else {
                                self.noMoreData = true
                            }
                            // decode json data
                            let decoder = JSONDecoder()
                            if let userData = try? decoder.decode([User].self, from: data) {
                                complete( true, userData, nil )
                            } else {
                                print("Status code: \(response.statusCode)")
                                complete( false, Array(), nil)
                            }
                        }
                        }.resume()
                } else {
                    print("Invalid URL.")
                }
            }
        }
    }
}
