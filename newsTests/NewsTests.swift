//
//  NewsTests.swift
//  NewsTests
//
//  Created by Benjamin Fantini on 8/30/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import XCTest
@testable import news

class NewsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Setup networking using api config shared instance
        ApiConfig.setup(baseUrlString: "https://hn.algolia.com/api/v1/")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStoriesEndPoint() {
        let promise = expectation(description: "Story list reachable")

        Story.getStories { succeed, error in
            if succeed {
                promise.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5,
                            handler: nil)
    }
    
}
