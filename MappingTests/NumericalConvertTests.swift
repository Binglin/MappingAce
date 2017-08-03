//
//  NumericalConvertTests.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/25.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import XCTest
@testable import Mapping
@testable import MappingAce


class NumericalConvertTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIntExample() {
        
        let intDic: [String : Any] = ["int" : 1]
        if let int = intDic["int"] as? NSNumber{
            let asint = int.intValue
            XCTAssertEqual(asint, 1)
        }else{
            XCTFail("此路不通")
        }
    }
    
    func testFloatExample() {
        
        let floatDic: [String : Any] = ["float" : 1]
        if let float = floatDic["float"] as? NSNumber{
            let asfloat = float.floatValue
            XCTAssertEqual(asfloat, 1)
        }else{
            XCTFail("此路不通")
        }
    }
    
    func testTimeIntervalExample() {
        
        let timeintervalDic: [String : Any] = ["timeinterval" : 1]
        if let timeinterval = timeintervalDic["timeinterval"] as? NSNumber{
            let astimeinterval = timeinterval.doubleValue
            XCTAssertTrue(astimeinterval == 1)
        }else{
            XCTFail("此路不通")
        }
    }
    
    
    func testBoolExample() {

        let boolStringTrue = Bool.mappingWith(any: "true") as! Bool
        XCTAssertEqual(boolStringTrue, true)
        
        let boolStringFalse = Bool.mappingWith(any: "false") as! Bool
        XCTAssertEqual(boolStringFalse, false)
        
        let boolStringUpcaseTrue = Bool.mappingWith(any: "True") as! Bool
        XCTAssertEqual(boolStringUpcaseTrue, true)
        
        
        let boolBoolTrue = Bool.mappingWith(any: true) as! Bool
        XCTAssertEqual(boolBoolTrue, true)
        
        let boolBoolFalse = Bool.mappingWith(any: false) as! Bool
        XCTAssertEqual(boolBoolFalse, false)
        
        let boolInt0 = Bool.mappingWith(any: 0) as! Bool
        XCTAssertEqual(boolInt0, false)
        
        let boolInt1 = Bool.mappingWith(any: 1) as! Bool
        XCTAssertEqual(boolInt1, true)
        
        let boolInt10 = Bool.mappingWith(any: 10) as! Bool
        XCTAssertEqual(boolInt10, true)
        
        let v = Optional<Bool>.none.serializedValue()
        XCTAssertNil(v)
        
        
        let boolDic: [String : Any] = ["bool" : 0]
        if let bool = boolDic["bool"] as? NSNumber{
            let asBool = bool.boolValue
            XCTAssertEqual(asBool, false)

        }else{
            XCTFail("此路不通")
        }
    }
    
    func testSwiftBoolFunc(){
        
        let boolfalseString = Bool.init("false")
        let booltrueString  = Bool.init("true")
        
        let boolInt0 = Bool.init("0")
        let boolInt1 = Bool.init("1")
        
        XCTAssertEqual(booltrueString, true)
        XCTAssertEqual(boolfalseString, false)
        XCTAssertEqual(boolInt0, nil)
        XCTAssertEqual(boolInt1, nil)
    }
}
