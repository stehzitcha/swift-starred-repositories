//
//  RepositoryDetails.swift
//  swift-starred-repositories
//
//  Created by Stella Iemma Braz on 14/10/19.
//  Copyright © 2019 stella. All rights reserved.
//

import Foundation

struct RepositoryDetails {
    public struct Keys {
        static let repoName = "name"
        static let repoStars = "stargazers_count"
        static let repoOwnerPicture = "avatar_url"
        static let repoOwnerName = "login"
    }
    
    let repoName: String
    let repoStars: Int
    let repoOwnerPicture: URL
    let repoOwnerName: String
    
    init? (from dictionary: NSDictionary) {
        
        guard let repoName = dictionary[Keys.repoName] as? String,
            let repoStars = dictionary[Keys.repoStars] as? Int,
            let repoOwnerPictureString = dictionary[Keys.repoOwnerPicture] as? String,
            let repoOwnerPicture = URL(string: repoOwnerPictureString),
            let repoOwnerName = dictionary[Keys.repoOwnerName] as? String
            else { return nil }
        
        self.repoName = repoName
        self.repoStars = repoStars
        self.repoOwnerPicture = repoOwnerPicture
        self.repoOwnerName = repoOwnerName
    }
}
