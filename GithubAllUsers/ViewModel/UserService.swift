//
//  UserService.swift
//  GithubAllUsers
//
//  Created by Laura on 2020/3/3.
//  Copyright © 2020 Laura. All rights reserved.
//

import Foundation

class UserService {

    func download(complete: @escaping ( _ success: Bool, _ users: [User], _ error: Error? )->() ) {
        DispatchQueue.global().async {
            let address = "https://api.github.com/users?since=0"
            if let url = URL(string: address) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else if let response = response as? HTTPURLResponse, let data = data {
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
