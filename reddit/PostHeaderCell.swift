//
//  PostHeadCell.swift
//  reddit
//
//  Created by Jonathan Tran on 2/16/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import UIKit

//class PostHeaderCell: UICollectionViewCell {
class HeaderPostCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var post: Post? {
        didSet {
            titleLabel.text = post?.title
            postImageView.image = post?.thumbnailImage
            selfTextLabel.text = post?.selfText
            
            let commentsText = String(post?.numComments as Int!) + " comments"
            
            domainAndCommentsLabel.text = (post?.domain!)! + " | " + commentsText
        }
    }
    
    var delegate: CellLinkClickDelegate?
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.lightGray
        imageView.layer.borderWidth = 0.6
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        var blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        var blurView = UIVisualEffectView(effect: blur)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        return imageView
    }()
    
    let blurView: UIVisualEffectView = {
       
        let blur = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let visualEffectView = UIVisualEffectView(effect: blur)
        return visualEffectView
        
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Name"
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let domainAndCommentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    let selfTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    func linkClicked() {
        if let delegate = self.delegate {
            delegate.openLink((post?.url)!)
        }
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(titleLabel)
        addSubview(postImageView)
        addSubview(domainAndCommentsLabel)
        addSubview(selfTextLabel)
        postImageView.addSubview(blurView)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(HeaderPostCell.linkClicked))
        singleTap.numberOfTapsRequired = 1;
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(singleTap)
        
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-[v1(22)]-8-|", views: titleLabel, postImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: domainAndCommentsLabel)
        
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1]-8-|", views: titleLabel, domainAndCommentsLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0(50)]|", views: postImageView)
        
        addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: blurView)
        addConstraintsWithFormat(format: "V:|-0-[v0]-0-|", views: blurView)
    }
}

    
