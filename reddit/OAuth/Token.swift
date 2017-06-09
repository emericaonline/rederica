//
//  Token.swift
//  reddit
//
//  Created by Jonathan Tran on 2/18/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import Foundation


public protocol Token {
    var accessToken: String { get }
    var refreshToken: String { get }
    var expiresIn: Int { get }
    var scope: String { get }
    var tokenType: String { get }
    var receivedTime: Int { get }
    
}
