//
//  GenericPostCell.swift
//  reddit
//
//  Created by Jonathan Tran on 2/13/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import Foundation
import UIKit


class genericPostCell: UICollectionViewCell {
    
    var delegate: CellCommentClickDelegate?
    
    var post: Post? {
        
        didSet {
 
            let font = UIFont(name: "HelveticaNeue-Light", size: 15)
            let attrib = [ NSFontAttributeName : font! ]
            let attribText = NSAttributedString(string: (post?.title) ?? "", attributes: attrib)
            
            
            let sub = post?.subreddit ?? " "
            let domain = post?.domain ?? " "
            let author = post?.username ?? " "
            
            let token = " ● "
            
            let stringPre = "\n\n"
            
            let string = sub
                
            let stringPost = token + domain + token + author
            
            
            let attribPre = [ NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 5)!, NSForegroundColorAttributeName : UIColor.lightGray]
            let attribMid = [ NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 10)!, NSForegroundColorAttributeName : UIColor.red]
            let attribPost = [ NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 10)!, NSForegroundColorAttributeName : UIColor.lightGray]
            
            let attribPreFormat = NSAttributedString(string: stringPre, attributes: attribPre)
            let attribFormat = NSAttributedString(string: string, attributes: attribMid)
            let attribPostFormat = NSAttributedString(string: stringPost, attributes: attribPost)
            
           
            let combinedString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attribText)
            combinedString.append(attribPreFormat)
            combinedString.append(attribFormat)
            combinedString.append(attribPostFormat)
            titleLabel.attributedText = combinedString
            
           
            let score = post?.score
            let createdUTC = post?.createdUTC
            let current = Date().timeIntervalSince1970
            let timeDiff = current - createdUTC!
            let timeString = convertToTimeStringFrom(timeDiff)
            let numComments = post?.numComments
            commentCountLabel.text = String(numComments as Int? ?? 0)
            
            voteTimeLabel.text = convertToScoreStringFrom(score!) + token + timeString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabel: UILabel = {
        let inset = UIEdgeInsetsMake(0, 0, 5, 0)
        let initialRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let paddedFrame = UIEdgeInsetsInsetRect(initialRect, inset)
        var label = UILabel(frame: paddedFrame)
        label.text = "Sample Name"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    var dividerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.backgroundColor = UIColor.lightGray
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let commentViewContainer: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let commentViewBox: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y:0, width: 50, height: 50)
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.6
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    } ()
    
    let voteTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 7)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    func viewClicked() {
        if let delegate = self.delegate {
            delegate.openPostComments(post: post!)
        }
    }
    
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(titleLabel)
        addSubview(commentViewContainer)
        addSubview(dividerView)
        commentViewContainer.addSubview(commentViewBox)
        commentViewContainer.addSubview(voteTimeLabel)
        commentViewBox.addSubview(commentCountLabel)
        
        
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(viewClicked))
        singleTap.numberOfTapsRequired = 1;
        commentViewContainer.isUserInteractionEnabled = true
        commentViewContainer.addGestureRecognizer(singleTap)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-[v1(0.4)]-[v2(44)]-|", views: titleLabel, dividerView, commentViewContainer)
        
    
        addConstraintsWithFormat(format: "V:|-[v0]-|", views: titleLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: commentViewContainer)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]", views: dividerView)
        
        addConstraintsWithFormat(format: "H:|-0-[v0(36)]-|", views: commentViewBox)
        addConstraintsWithFormat(format: "H:|-0-[v0]", views: voteTimeLabel)
        addConstraintsWithFormat(format: "V:|-9-[v0(9)]-2-[v1(20)]", views: voteTimeLabel, commentViewBox)
        
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: commentCountLabel)
        addConstraintsWithFormat(format: "V:|-2-[v0(16)]", views: commentCountLabel)
    }
    
}
