//
//  post.swift
//  reddit
//
//  Created by Jonathan Tran on 11/17/16.
//  Copyright © 2016 Jonathan Tran. All rights reserved.
//

import Foundation
import UIKit

class Post
{
    //MARK: Properties
    var title: String?
    var selfPost: Bool?
    var url: String?
    var thumbnailUrl: String?
    var thumbnailImage: UIImage?
    var subreddit: String?
    var domain: String?
    var username: String?
    var name: String? //post ID
    var score: Int?
    var createdUTC: Double?
    var numComments: Int?
    var selfText: String?
//    var username: String?
//    var subreddit: Subreddit?

    
    //    var subreddit:
    //define a subreddit class??????
    
    
    
    //MARK: Initialization
    init(title: String, selfPost: Bool, url: String?, thumbUrl: String?, postSub: String?, domain: String?, username: String?){
        self.title = title
        self.selfPost = selfPost
        self.url = url
        self.thumbnailUrl = thumbUrl
        self.subreddit = postSub
        self.domain = domain
        self.username = username
    }
    init(){
        
    }
    
    
    
    
    
}
