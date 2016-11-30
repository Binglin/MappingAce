//
//  ArrayMappingTests.swift
//  Mapping
//
//  Created by ET|冰琳 on 2016/11/30.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import XCTest

@testable import MappingAce

class ArrayMappingTests: XCTestCase {
    
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
        let phonesInfo: [[String : Any]] = [["tel" : "xxx1", "type": "work11"],
                                            ["tel" : "xxx2", "type": "work22"],
                                            ["tel" : "xxx3", "type": "work33"]]
        
        let result = [PhoneNumber](jsonObjArray: phonesInfo)
        
        let first = result[0]
        let second = result[1]
        let third = result[2]
        
        XCTAssertEqual(first.tel, "xxx1")
        XCTAssertEqual(first.type, "work11")
        
        XCTAssertEqual(second.tel, "xxx2")
        XCTAssertEqual(second.type, "work22")
        
        XCTAssertEqual(third.tel, "xxx3")
        XCTAssertEqual(third.type, "work33")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
