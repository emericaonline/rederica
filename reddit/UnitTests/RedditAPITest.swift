//
//  RedditAPITest.swift
//  reddit
//
//  Created by Jonathan Tran on 3/20/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import XCTest
import reddit
@testable import reddit

class RedditAPITest: XCTestCase {
   
    let redAPI: RedditAPI = RedditAPI()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testTokenRetrieval() {
        let accessToken: String = KeychainService.loadAccessToken()! as String
        if(accessToken.isEmpty) {
            XCTAssert(false)
        }
    }
    
    func testTokenRenewal() {
        let renewalToken: String = KeychainService.loadRefreshToken()! as String
        if(renewalToken.isEmpty) {
            XCTAssert(false)
        }
    }
    
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
