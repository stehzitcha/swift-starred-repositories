//
//  Requests.swift
//  swift-starred-repositories
//
//  Created by Stella Iemma Braz on 12/10/19.
//  Copyright © 2019 stella. All rights reserved.
//

import Foundation
import UIKit

protocol RequestsDelegate: class {
    func didReceiveData(requests: Requests, dictionary: [NSDictionary])
}

class Requests {
    weak var delegate: RequestsDelegate?
    var count = 10
    var result:[NSDictionary] = []
    
    func makeRequest(fetching:Bool) {
        if fetching {
            count += 10
        }
        let urlString = "https://api.github.com/search/repositories?q=language:swift&sort=stars&per_page=\(count)"

        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                        
                        guard let jsonData = json["items"] as? [NSDictionary] else { return }
                        
                        self.result = jsonData.compactMap {
                            guard let name = $0["name"] as? String,
                                let stars = $0["stargazers_count"] as? Int,
                                let owner = $0["owner"] as? NSDictionary,
                                let ownerName = owner["login"] as? String,
                                let ownerAvatarURLString = owner["avatar_url"] as? String else { return nil }
                            
                            let dictionary = NSDictionary(dictionary:
                                ["name": name, "stargazers_count": stars,
                                 "login": ownerName, "avatar_url": ownerAvatarURLString]
                            )
                            
                            return dictionary
                        }
                        
                        DispatchQueue.main.async {
                            self.delegate?.didReceiveData(requests: self, dictionary: self.result)
                            
                        }
                    }
                } catch let error {
                    print(error)
                }
        }.resume()
    }
}
