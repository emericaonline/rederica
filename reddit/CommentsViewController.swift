//
//  CommentsViewController.swift
//  reddit
//
//  Created by Jonathan Tran on 1/27/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import UIKit


protocol CellLinkClickDelegate {
    func openLink(_ url: String)
}

class CommentsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CellLinkClickDelegate {
  
    //TODO: user defaults to save preferences and junk.
    //let userDefaults;
    
    //MARK: Members
    let cellId = "cellId"
    let headerId = "headerId"
    var post: Post
    let RedApi = RedditAPI()
    var CommentDict: NSDictionary?
    var array: [Comment]?
    var depth: Int = 0
    
    var cabinet: CommentCabinet = CommentCabinet()
    
   
    //MARK: Methods
    init(post: Post)
    {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.didLoadComments(notification:)), name: CommentCabinetDidLoadCommentsName, object: nil)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        self.collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.register(HeaderPostCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        navigationItem.title = "Comments"
        navigationController?.hidesBarsOnSwipe = true
        
        //want the navigation bar to reset to being shown.
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: 100, height: 100)

        collectionView?.collectionViewLayout = layout
        
       
        
        cabinet.load(article: post.name ?? "", subreddit: post.subreddit)
    }
   
    
    func didLoadComments(notification: NSNotification) {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cabinet.comments.count
    }

    
    // Configure the cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CommentCell
        cell?.bodyLabel.text = cabinet.comments[indexPath.item].body
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text: String = (cabinet.comments[indexPath.item].body) else {
            print("error")
            return CGSize(width: view.frame.width, height: 60)
        }
        
        let knownWidth: CGFloat = 8 + 8
        let bodyRect = NSString(string: text).boundingRect(with: CGSize(width: (view.frame.width - knownWidth), height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
        let indent = cabinet.comments[indexPath.item].depth
        
        if (cabinet.comments[indexPath.item].isHidden == true) {
            return CGSize(width: view.frame.width, height: 0)
        } else {
            
            return CGSize(width: view.frame.width - CGFloat(indent! * 25), height: bodyRect.height + 16)
        }
    }
   
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderPostCell
        header.post = post
        header.delegate = self
        return header
    }
   
    //Alter this to get all the things from the standard locations.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let knownWidth: CGFloat = 8 + 8 + 22
        let titleText = post.title
        let selfText = post.selfText
        let titleRect = NSString(string: titleText ?? "").boundingRect(with: CGSize(width: (view.frame.width - knownWidth), height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
        
        
        let selfTextRect = NSString(string: selfText ?? "").boundingRect(with: CGSize(width: (view.frame.width - knownWidth), height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
       
        let knownHeight: CGFloat = 8 + 8 + 8
        
        if (ceil(knownHeight + 8 + (titleRect.height) + (selfTextRect.height)) < (8 + 8 + 44)) {
            return CGSize(width: ceil(view.frame.width), height: (8 + 8 + 44))
        } else {
            return CGSize(width: ceil(view.frame.width), height: ceil(knownHeight + 8 + (selfTextRect.height + titleRect.height)))
        }
        
        
        
    }

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let count = cabinet.childrenOfComment(index: indexPath.item)
        
        
        //This is messy and hard to understand, perhaps abstract it out.
        for index in indexPath.item..<(indexPath.item + 1 + count) {
        
            let cell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) as? CommentCell
            cell?.toggleConstraints()
        }
        
        cabinet.toggleHidden(start: indexPath.item + 1, count: count)
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func openLink(_ url: String) {
        let webVC = WebViewController(url: url)
        navigationController?.pushViewController(webVC, animated: true)
    }
}

//todo finish self text specific views
class SelfTextHeaderPost: HeaderPostCell
{
    
    
//        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1]-8-|", views: titleLabel, selfTextLabel)
//        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: selfTextLabel)
}

