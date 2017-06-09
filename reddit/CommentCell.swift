//
//  CommentCell.swift
//  reddit
//
//  Created by Jonathan Tran on 4/24/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell
{

    var comment: Comment = Comment()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if (frame.height != 0) {
            setupViews()
        }
    }
    
    
    required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        backgroundColor = UIColor.white
        addSubview(bodyLabel)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: bodyLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: bodyLabel)
    }
    
    func toggleConstraints() {
        for constraint in self.constraints {
            if (constraint.constant == 0) {
                constraint.constant = 1
            }
            else {
                constraint.constant = 0
            }
        }
    }
    
}
