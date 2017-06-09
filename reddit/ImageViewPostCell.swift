//
//  ImageViewPostCell.swift
//  reddit
//
//  Created by Jonathan Tran on 2/13/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import Foundation
import UIKit


//MARK: cell with Image
class ThumnbnailPostCell: genericPostCell{
   //need to call some parent initializer stuff, overload it
    override var post: Post? {
        didSet {
            
            let font = UIFont(name: "HelveticaNeue-Light", size: 15)
            let attrib = [ NSFontAttributeName : font! ]
            let attribText = NSAttributedString(string: (post?.title!)!, attributes: attrib)
            
            
            
            let sub = post?.subreddit
            let domain = post?.domain
            let author = post?.username
            
            let token = " ● "
            
            let stringPre = "\n\n"
            
            let string = sub!
                
            let stringPost = token + domain! + token + author!
            
            
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
            
            //need a way to set specific posts maybe
            postImageView.image = post?.thumbnailImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImageView:UIImageView = {
        let imageView = UIImageView()
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 0.6
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    override func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(titleLabel)
        addSubview(postImageView)
        addSubview(commentViewContainer)
        addSubview(dividerView)
        commentViewContainer.addSubview(commentViewBox)
        commentViewContainer.addSubview(voteTimeLabel)
        commentViewBox.addSubview(commentCountLabel)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(genericPostCell.viewClicked))
        singleTap.numberOfTapsRequired = 1;
        commentViewContainer.isUserInteractionEnabled = true
        commentViewContainer.addGestureRecognizer(singleTap)
        
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]-8-[v2(0.4)]-[v3(44)]-8-|", views: postImageView, titleLabel, dividerView, commentViewContainer)
        
        addConstraintsWithFormat(format: "V:|-[v0]-|", views: titleLabel)
        addConstraintsWithFormat(format: "V:|-10-[v0(44)]", views: postImageView)
        addConstraintsWithFormat(format: "V:|-8-[v0]-|", views: commentViewContainer)
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]", views: dividerView)
        
        
        addConstraintsWithFormat(format: "H:|-0-[v0(36)]-|", views: commentViewBox)
        addConstraintsWithFormat(format: "H:|-0-[v0]", views: voteTimeLabel)
        addConstraintsWithFormat(format: "V:|-9-[v0(9)]-2-[v1(20)]", views: voteTimeLabel, commentViewBox)
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: commentCountLabel)
        addConstraintsWithFormat(format: "V:|-3-[v0(16)]", views: commentCountLabel)
    }
    
    
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    func addConstraintsWithFormat(_ format: String, views: UIView..., priority: Int) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        let constraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary)
        constraint.first?.priority = Float(priority)
        addConstraints(constraint)
    }
    
}
