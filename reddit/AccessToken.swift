//
//  AccessToken.swift
//  reddit
//
//  Created by Jonathan Tran on 3/24/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import Foundation


class AccessToken: Token {
    
    public let accessToken: String
    public let expiresIn: Int
    public let scope: String
    public let tokenType: String
    public let refreshToken: String
    public let receivedTime: Int
    
    public init() {
        accessToken = ""
        expiresIn = 0
        scope = ""
        tokenType = ""
        refreshToken = ""
        receivedTime = 0
    }
}
