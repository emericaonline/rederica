//
//  ViewController.swift
//  reddit
//
//  Created by Jonathan Tran on 7/28/16.
//  Copyright © 2016 Jonathan Tran. All rights reserved.
//

import UIKit

let cellId = "cellId"
let selfPostId = "selfPostId"


protocol CellCommentClickDelegate {
    func openPostComments( post: Post)
}

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CellCommentClickDelegate {

    var dictionary: NSDictionary?
    var PostList = [Post]()
    var Items = [Any]()
    let RedApi = RedditAPI()
    var refreshControl: UIRefreshControl?
    var currentSubreddit: String = ""
    
    //MARK: Setup
    init(subreddit: String) {
        super.init(collectionViewLayout: UICollectionViewLayout())
        RedApi.postsFromSubreddit(subreddit: subreddit, onCompletion: {
            (postList: NSArray?, error: NSError?) in
            self.PostList = postList as! [Post]
            self.cacheThumbnailsForPosts()
        })
        currentSubreddit = subreddit
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
        
        RedApi.postsFromSubreddit() {
            (postList: NSArray?, error: NSError?) in
            self.PostList = postList as? [Post] ?? [Post]()
            self.cacheThumbnailsForPosts()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(ThumnbnailPostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(genericPostCell.self, forCellWithReuseIdentifier: selfPostId)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(FeedController.startRefresh), for: .valueChanged)
        

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //some lines are still thicker than others
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0.8

        collectionView?.collectionViewLayout = layout
        collectionView?.alwaysBounceVertical = true
        collectionView?.addSubview(refreshControl!)
        
        navigationItem.title = currentSubreddit
        navigationController?.hidesBarsOnSwipe = true
    }
    
    //MARK: Methods
    func startRefresh() {
        PostList = [Post]()
        self.collectionView?.reloadData()
        RedApi.postsFromSubreddit(subreddit: currentSubreddit) {
            (postList: NSArray?, error: NSError?) in
            self.PostList = postList as? [Post] ?? [Post]()
            self.cacheThumbnailsForPosts()
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        refreshControl?.endRefreshing()
    }
    
    func cacheThumbnailsForPosts()
    {
        RedApi.fetchImagesForPosts(postList: PostList)
        {
            //maybe use a callback to guarantee the images are loaded
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.view.setNeedsDisplay()
                
                for views in self.view.subviews {
                    for subview in views.subviews {
                        if (subview is UIImageView ) {
                            subview.reloadInputViews()
                            subview.setNeedsDisplay()
                        }
                    }
                }
            }
            
        }
        
    }
    
    func loadWebView(_ url: String) {
        let vc = WebViewController(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openPostComments( post: Post) {
        let vc = CommentsViewController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMorePosts()
    {
        RedApi.postsFromSubreddit(subreddit: currentSubreddit, count: PostList.count, after: PostList[PostList.endIndex-1].name ?? "")
        {
            (postList: NSArray?, error: NSError?) in
            self.PostList += postList as? [Post] ?? [Post]()
            self.cacheThumbnailsForPosts()
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    //MARK: CollectionView functions
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PostList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(PostList[indexPath.item].thumbnailUrl == "default" || PostList[indexPath.item].selfPost == true) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selfPostId, for: indexPath) as! genericPostCell
            cell.delegate = self
            cell.post = PostList[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ThumnbnailPostCell
            cell.delegate = self
            cell.post = PostList[indexPath.item]
            return cell
        }
    }
    
    //Determines size of cells. Baed on text sizes and extra padding.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //we can also get whether or not its gonna be a picture view or a self post styl
        var hasThumb: Bool = true
        
        let imageViewSize: CGFloat = 44
        let defaultSize: CGFloat = imageViewSize + 10 + 10
        
        
        //basically check to see if the thumbnail url is default ew.
        if let thumbUrl = PostList[indexPath.item].thumbnailUrl {
            if thumbUrl == "default" {
                hasThumb = false
            }
        }
        //refactor this by a lot
        //TODO: Above
        //
        let usernameText = PostList[indexPath.item].username
        if let titleText = PostList[indexPath.item].title {
            
            //Determining width
            var knownWidth: CGFloat
            if hasThumb == true {
                
                knownWidth = CGFloat(44 + 44 + 8 + 8 + 8 + 8 + 0.4 )
            } else {
                
                knownWidth = CGFloat(8 + 8 + 8 + 44 + 0.4)
            }
            
            //Determining Height
            let heightOfTitle = NSString(string: titleText).boundingRect(with: CGSize(width: (view.frame.width - knownWidth), height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 15)!], context: nil).height
            
            let heightOfSubLabel = NSString(string: (usernameText ?? "")).boundingRect(with: CGSize(width: 1000, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 10)!], context: nil).height
            
            
            let heightOfSpace = NSString(string: "\n\n").boundingRect(with: CGSize(width: 1000, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 5)!], context: nil).height
         
            
            let heightOfNewlineAndSublabel: CGFloat = heightOfSubLabel + heightOfSpace
            
            
            // We have a default smallest size of 10 + 10 + 44, will probably want to examine members of the cell? to see if we can dynamically size in the constraints.
            let height: CGFloat = ceil(heightOfNewlineAndSublabel + 8 + (heightOfTitle))
            
            
            
            if (height < defaultSize) {
                return CGSize(width: ceil(view.frame.width), height: defaultSize)
            } else {
                return CGSize(width: ceil(view.frame.width), height: ceil(heightOfNewlineAndSublabel + 8 + (heightOfTitle)))
            }
        }
        
        //Default return value.
        return CGSize(width: view.frame.width, height: defaultSize)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastItem = PostList.count-1
       
        if (indexPath.item == lastItem) {
            loadMorePosts()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if (PostList[indexPath.row].selfPost == true) {
            openPostComments(post: PostList[indexPath.row])
            return true
        }
        let urlOfPost = PostList[indexPath.row].url as String!
        loadWebView(urlOfPost ?? "")
        return true
    }
    
}
