
//
//  TestSuite.swift
//  Roomie
//
//  Created by Menita Vedantam on 11/30/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import XCTest
@testable import Roomie


class TestSuite: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateNewAccount() {
        print("Running tests...")
        var passed = false
        let badEmail = "npt"
        let goodEmail = "menita@gmail.com"
        let badPassword = "dfg"
        let goodPassword = "asdfghj"
        if (!isValidEmail(badEmail) && isValidEmail(goodEmail) && !testPassword(badPassword) && testPassword(goodPassword)){
            passed = true
        }
        if (passed){
            print("Create New Account: PASSED")
        }
        else{
            print("Create New Account: FAILED")
        }
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testPassword(password: String) ->Bool{
        if (password.count > 6){
            return true
        }
        else{
            return false
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
