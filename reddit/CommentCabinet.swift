//
//  File.swift
//  reddit
//
//  Created by Jonathan Tran on 4/30/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import Foundation
import UIKit

let CommentCabinetDidLoadCommentsName = Notification.Name(rawValue: "CommentCabinetDidLoadComments")

class CommentCabinet {
    var comments:[Comment] = [Comment]()
    var depth: Int = 0
    
    let RedApi: RedditAPI = RedditAPI()
    
    
    //Refactor this, its ugly as hell. Create a smarter way to parse through the children.
    //For now we can keep this, but lets condense the two different kinds of lists into one that keeps track of both.
    func getChildren(dict: NSDictionary) {
        if ( dict != nil) {
            let body = dict.value(forKeyPath: "data.children.data.body") as! NSArray
            
            let replies = (dict.value(forKeyPath: "data.children.data.replies") as! NSArray)
            var i: Int = 0;
            for bodies in body {
                if !(bodies is NSNull) {
                    
                    let newComment: Comment = Comment()
                    newComment.body = (bodies as! String)
                    newComment.depth = depth
                    
                    comments.append(newComment)
                    if replies[i] is String {
                    }
                    else if replies[i] is NSDictionary {
                        depth += 1
                        getChildren(dict: replies[i] as! NSDictionary)
                        depth -= 1
                    }
                    i += 1
                }
            }
        }
    }
    
    //returns count of children from index position
    func childrenOfComment(index: Int) -> (Int) {
        var childrenCount: Int = 0
        for i in index..<comments.count {
            if comments[index].depth! < comments[i].depth! {
                childrenCount += 1
            }
           
            //Fix this code so i don't need a comment
            //if its not itself, and the depth has reached its same depth we break out.
            else if (index != i) && (comments[index].depth == comments[i].depth) {
                break
            }
            
            
        }
        //loop through starting from index to until we find a depth higher or the end.
        
        
        
        return childrenCount
    }
    
    func toggleHidden(start: Int, count: Int) {
        for i in start..<(start + count) {
            
            comments[i].isHidden = !comments[i].isHidden
        }
    }
    
    
    func load(article: String?, subreddit: String?)
    {
        RedApi.fetchCommentsFromPostWithId(post: article!, subreddit: subreddit!) { (dict, error) in
            self.getChildren(dict: dict!)
            
            
            
            NotificationCenter.default.post(name: CommentCabinetDidLoadCommentsName, object: nil)
        }
    }
    
    
    func getHeight() -> CGFloat {
        var height: CGFloat = 0
       
        
        return height
    }
    
}



