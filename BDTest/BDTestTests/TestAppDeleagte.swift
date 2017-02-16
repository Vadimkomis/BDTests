//
//  TestAppDeleagte.swift
//  BDTest
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import XCTest
@testable import BDTest

class TestAppDeleagte: XCTestCase {
    
   
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let bdTests = BDTestsMain(enviornmentName: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let test  = bdTests.createTest(jsonString: "{\"key\":\"value\"}", jsonFile: nil, httpCode: 200)
        XCTAssert(test)
        XCTAssert(appDelegate.isLaunched)
        appDelegate.testEnv()
        XCTAssert(appDelegate.isTest)
    }
    
}
