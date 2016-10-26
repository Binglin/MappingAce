//
//  SwiftStructNullableTests.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import XCTest
@testable import Mapping

private struct User: Serializable{
    var age: Int?
    var name: String?
    var phone: PhoneNumber?
}

private struct PhoneNumber: Mapping {
    var tel: String
    var type: String
}

class SwiftStructNullableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllNilExample() {
        
        let user = MappingAny(type: User.self, fromDic: [:])
        let dic = user.toDictionary()
        print(dic)
        
        let dicNull = user.toNullableValueDictionary()
        print(dicNull)
        
        XCTAssertEqual(user.age, nil)
        XCTAssertEqual(user.name, nil)
        XCTAssertEqual(user.phone?.tel, nil)
        XCTAssertEqual(user.phone?.type, nil)
    }
    
    
    func testSomeNilExample(){
        
        let dic: [String : Any] = [
            "name": "Binglin",
        ]
        
        let user = MappingAny(type: User.self, fromDic: dic)
        
        XCTAssertEqual(user.age, nil)
        XCTAssertEqual(user.name, "Binglin")
        XCTAssertEqual(user.phone?.tel, nil)
        XCTAssertEqual(user.phone?.type, nil)

    }
    
    func testPhoneNotNilExample(){
        
        let dic: [String : Any] = [
            "name": "Binglin",
            "phone": ["tel" : "xxx", "type": "work"]
        ]
        
        let user = MappingAny(type: User.self, fromDic: dic)
        
        let serialized = user.toDictionary()
        XCTAssertEqual(dic as NSDictionary, serialized as NSDictionary)
        
        XCTAssertEqual(user.age, nil)
        XCTAssertEqual(user.name, "Binglin")
        XCTAssertEqual(user.phone?.tel, "xxx")
        XCTAssertEqual(user.phone?.type, "work")
        
    }
}
