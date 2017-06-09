//
//  RedditAPI.swift
//  reddit
//
//  Created by Jonathan Tran on 1/22/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import Foundation
import UIKit


class RedditAPI
{
//    let baseUrl = "https://www.reddit.com/"
    let baseUrl = "https://oauth.reddit.com/"
    let suffixUrl = ".json"
    let userAgent = "RedditTestClient/0.1"
    let client_id = "HIDDENFORREASONS"
    
    let userDefaults = UserDefaults()
    
    //TODO: Convert this function to use oauth for userless and user full
    //GET [/r/subreddit]/comments/article
    /*
         Get the comment tree for a given Link article.
         If supplied, comment is the ID36 of a comment in the comment tree for article. This comment will be the (highlighted) focal point of the returned view and context will be the number of parents shown.
         depth is the maximum depth of subtrees in the thread.
         limit is the maximum number of comments to return.
         See also: /api/morechildren and /api/comment.
    */
    
    
    
    //REALLY NEED to handle 403, 401, or 404 errors otherwise we'll get crashes
    func commentsFromArticle( article: String, subreddit: String, onCompletion: @escaping (NSDictionary?, NSError?) -> Void)
    {
//        checkToken()
        
        
        
    }
    
    
    
    
    
    //Will become deprecated from above:
    func fetchCommentsFromPostWithId( post: String, subreddit: String, onCompletion: @escaping (NSDictionary?, NSError?) -> Void)
    {
        let postStripped = post.replacingOccurrences(of: "t3_", with: "")
        let urlString = baseUrl + "r/" + subreddit + "/comments/" + postStripped + "/" + suffixUrl
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
        let authString: String = "bearer " + (KeychainService.loadAccessToken() as String?)!
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        request.addValue("1", forHTTPHeaderField: "raw_json")
        request.setValue("RedditTestClient/0.1", forHTTPHeaderField: "User-Agent")
            
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        { (data, response, error) in
            if let response = response {
                if let data = data {
//                    print(data)
                    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                    onCompletion(json[1] as? NSDictionary ?? NSDictionary(), nil)
                    
                    
                    
//                    onCompletion(json as? NSDictionary ?? NSDictionary(), nil)
                } else {
                    fatalError("data is empty")
                }
            }
        }
        task.resume()
    }
    
    
    func postsFromSubreddit( subreddit: String = "", onCompletion: @escaping (NSArray?, NSError?) -> Void)
    {
        checkToken() { () -> () in
            
        //get token here
        //build url
        var urlString: String = self.baseUrl
        
        if(!subreddit.isEmpty) {
            urlString = self.baseUrl + "r/" + subreddit
        }
        
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "GET"
           
            let authString: String = "bearer " + (KeychainService.loadAccessToken() as String?)!
            request.addValue(authString, forHTTPHeaderField: "Authorization")
            request.addValue("1", forHTTPHeaderField: "raw_json")
            request.setValue("RedditTestClient/0.1", forHTTPHeaderField: "User-Agent")
            
//            print(request)
            let task = URLSession.shared.dataTask(with: request as URLRequest)
            {
               (data, response, error) in
                if let data = data {
//                    print(data)
                    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                    print(json)
                    let postList = self.scrapeDictionaryForPost(json as NSDictionary!)
                    onCompletion(postList, nil)
                }
                if let response = response {
                }
            }
            task.resume()
        }
    }
    
    
    func taskForListings(with: URLRequest) -> URLSessionDataTask
    {
        let task = URLSession.shared.dataTask(with: with)
        {
           (data, response, error) in
            if let data = data {
//                print(data)
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                print(json)
                let postList = self.scrapeDictionaryForPost(json as NSDictionary!)
            }
        }
        return task
    }
    
    func postsFromSubreddit( subreddit: String = "", count: Int, after: String, onCompletion: @escaping (NSArray?, NSError?) -> Void)
    {
        var urlString: String
        if(subreddit != ""){
            urlString = baseUrl + "r/" + subreddit + "/" + "?count=" + String(count)
        } else {
            urlString = baseUrl + subreddit + "?count=" + String(count)
        }
        
        let urlStringSecond =  "&after=" + after
        
        urlString += urlStringSecond
       
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
        let authString: String = "bearer " + (KeychainService.loadAccessToken() as String?)!
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        request.addValue("1", forHTTPHeaderField: "raw_json")
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
            
//        print(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {
            (data, response, error) in
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let postList = self.scrapeDictionaryForPost(json as NSDictionary!)
                onCompletion(postList, nil)
            }
        }
        task.resume()
    }
    
    
    
   
    //Extract all the crap
    func scrapeDictionaryForPost(_ dictionary: NSDictionary) -> NSArray
    {
        let postList = NSMutableArray()
        let dictWhole = dictionary.value(forKeyPath: "data.children.data")
        for(value) in dictWhole as! NSArray{
            let value: NSDictionary = value as! NSDictionary
            let title = value.value(forKey: "title") as? String
            
            let isSelf = value.value(forKey: "is_self")
            let url = value.value(forKey: "url")
            let thumbUrl = value.value(forKey: "thumbnail")
            let author = value.value(forKey: "author")
            let subreddit = value.value(forKey: "subreddit")
            let domain = value.value(forKey: "domain")
            let name = value.value(forKey:"name")
            let score = value.value(forKey:"score")
            let createdUTC = value.value(forKey:"created_utc")
            let numComments = value.value(forKey:"num_comments")
            let selfText = value.value(forKey:"selftext")
            if let boolean = isSelf {
                let post = Post(title: title!, selfPost: boolean as! Bool, url: url as? String, thumbUrl: thumbUrl as? String, postSub: subreddit as? String, domain: domain as? String, username: author as? String)
                post.name = name as? String
                
                post.score = score as? Int
                
                post.thumbnailUrl = post.thumbnailUrl?.replacingOccurrences(of: "&amp;", with: "&")
                post.url = post.url?.replacingOccurrences(of: "&amp;", with: "&")
                post.createdUTC = createdUTC as? Double
                post.numComments = numComments as? Int
                post.selfText = selfText as? String
                postList.add(post)
            }
        }
        return postList
    }
    
    func fetchImagesForPosts( postList: [Post], onCompletion: @escaping () -> ())
    {
        for post in postList  {
            fetchImage(url: post.thumbnailUrl as String?) {
                (data, error) in
                post.thumbnailImage = UIImage(data: data!)
            }
        }
        onCompletion()
    }
    
    func fetchImage( url: String?, onCompletion: @escaping (Data?, Error?) -> Void)
    {
        let task = URLSession.shared.dataTask(with: URL(string: url!)!) {
           (data, response, error) in
            if let data = data {
                onCompletion(data, nil)
            }
        }
        task.resume()
    }
    
   
    func requestToken()
    {
        let authorization: String = AppDelegate.authenticationString ?? ""
        
        let loginString = String(format: "%@: ", client_id)
        
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let url = URL(string: "https://www.reddit.com/api/v1/access_token/")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let postString = "grant_type=authorization_code&code=" + authorization + "&redirect_uri=rederica://response"
        
        
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
//        print(request)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (Data, Response, Error) in
            if let data = Data {
//                print(data)
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let dictionary = json as NSDictionary
                let refresh_token = dictionary.value(forKey: "refresh_token")
//                print(refresh_token!)
                
                KeychainService.saveRefreshToken(token: refresh_token as! NSString)
                
                let access_token = dictionary.value(forKey: "access_token")
               
                //todo do something with this access token
                let expiresIn = dictionary.value(forKey: "expires_in") // 3600 but could change.
                
                self.resetTokenTimer(expires_in: expiresIn as? Int ?? 3600)
                KeychainService.saveAccessToken(token: access_token as! NSString)
                
                
//                print(json)
            }
            if let response = Response {
//                print(response)
            }
            //Check error???
        }
        task.resume()
    }
    
    func refreshToken(completed: @escaping () -> ()) {
        
        let loginString = String(format: "%@: ", client_id)
        
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let url = URL(string: "https://www.reddit.com/api/v1/access_token/")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let refreshToken =  KeychainService.loadRefreshToken()
        let postString = "grant_type=refresh_token&refresh_token=" + (refreshToken as! String)
        
        
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (Data, Response, Error) in
            if let response = Response as? HTTPURLResponse {
                if (self.checkResponse(responseCode: response.statusCode) == true)
                {
                    if let data = Data {
                        //do something here!
                        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let dictionary = json as NSDictionary
                        let access_token = dictionary.value(forKey: "access_token")
                       
                        //todo do something with this access token
                        let expiresIn = dictionary.value(forKey: "expires_in") // 3600 but could change.
                        
                        self.resetTokenTimer(expires_in: expiresIn as? Int ?? 3600)
                        KeychainService.saveAccessToken(token: access_token as! NSString)
                        completed()
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func logout()
    {
        KeychainService.deleteTokens()
        let task = URLSession.shared.dataTask(with: URL(string: "http://www.reddit.com/logout")!) {
            (Data, Response, Error) in
        }
        task.resume()
    }
    
    
    
    func getUserlessToken()
    {
        //generate a device id
        //grant_type=client_credentials
    }
    
    func checkResponse(responseCode: Int ) -> Bool{
        switch responseCode {
        case 404:
            print("Not found.")
            return false
        case 401:
            print("Access denied. Might have to refresh token.")
            return false
        default:
            return true
        }
    }
    
    func resetTokenTimer(expires_in: Int) {
        
        let date = Date()
        userDefaults.set(expires_in, forKey: "expires_in")
        userDefaults.set(date, forKey: "token_time")
        
    }
    
    func checkToken(completed: @escaping () -> ()) {
        let tokenTime = userDefaults.object(forKey: "token_time")
        let expiresIn = userDefaults.integer(forKey: "expires_in")
        
        
        let interval = Date().timeIntervalSince(tokenTime as? Date ?? Date())
        
        if (interval > Double(expiresIn) ) {
            refreshToken() { () -> () in
                completed()
            }
        }
        else {
            completed()
        }
    }
    
}
