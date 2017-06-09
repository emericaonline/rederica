//
//  Comments.swift
//  reddit
//
//  Created by Jonathan Tran on 2/12/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import UIKit
import Foundation


class Comment {
    var body: String?
    var body_html: String?
    var depth: Int?
    var user: String?
    var timeCreatedUTC: UInt?
    var isHidden: Bool = false
    var height: CGFloat?
}
