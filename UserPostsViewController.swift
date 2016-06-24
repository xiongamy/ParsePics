//
//  UserPostsViewController.swift
//  ParsePics
//
//  Created by Amy Xiong on 6/24/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit
import Parse

class UserPostsViewController: FeedViewController {
    

    override func setQueryProperties() -> PFQuery {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        query.limit = queryLimit
        
        return query
    }

}
