//
//  JSONSerializationTests.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/25.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import XCTest
@testable import MappingAce

class JSONSerializationTests: XCTestCase {
    
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
        
        
        struct Company: Mapping {
            let name:String
            let id:Int
        }
        
        let companyInfo: [String : Any] = ["name" : "MappingAce", "id" : 1]
        
        let company = Company(fromDic: companyInfo)
        print(company.name)
        print(company.id)
        
        XCTAssertEqual(company.id, 1)
        XCTAssertEqual(company.name, "MappingAce")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
