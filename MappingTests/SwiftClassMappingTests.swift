//
//  SwiftClassMappingTests.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import XCTest
@testable import Mapping
@testable import MappingAce

class SwiftClassMappingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSwiftClassInitExample() {
        
        class User: InitMapping{
            var name: String = "default"
            var age: Int?
            
            required init() {}
        }
        
        let dic: [String : Any] = ["name" : "IB", "age": 14]
        let user = User(fromDic: dic)
        
        XCTAssertEqual(user.name, "IB")
        XCTAssertEqual(user.age, 14)
    }
    
    func testStructInitExample(){
        
        struct User: InitMapping{
            var name: String = "default"
            var age: Int?
        }
        
        let dic: [String : Any] = ["name" : "IB", "age": 14]
        let user = User(fromDic: dic)
        
        XCTAssertEqual(user.name, "IB")
        XCTAssertEqual(user.age, 14)
        
    }
    
    func testOCClassInitExample(){
        
        class User: NSObject, InitMapping{
            var name: String = "default"
            var age: Int?
            required override init() {}
        }
        
        let dic: [String : Any] = ["name" : "IB", "age": 14]
        let user = User(fromDic: dic)
        
        XCTAssertEqual(user.name, "IB")
        XCTAssertEqual(user.age, 14)
    }
    
    func testSwiftClassInitOptionalPropertyExample() {
        
        class User: InitMapping{
            var name: String = "default"
            var age: Int?
            
            required init() {}
        }
        
        let dic: [String : Any] = ["name" : "IB"]
        let user = User(fromDic: dic)
        
        XCTAssertEqual(user.name, "IB")
        XCTAssertEqual(user.age, nil)
    }
    
    func testStructInitOptionalPropertyExample(){
        
        struct User: InitMapping{
            var name: String = "default"
            var age: Int?
        }
        
        let dic: [String : Any] = ["age": 14]
        let user = User(fromDic: dic)
        
        XCTAssertEqual(user.name, "default")
        XCTAssertEqual(user.age, 14)
        
    }
    
    func testOCClassInitOptionalPropertyExample(){
        
        class User: NSObject, InitMapping{
            var name: String = "default"
            var age: Int?
            required override init() {}
        }
        
        let dic: [String : Any] = ["name" : "IB"]
        let user = User(fromDic: dic)
        
        XCTAssertEqual(user.name, "IB")
        XCTAssertEqual(user.age, nil)
    }
    
    /// 类继承
    /// TO CHECK: NSObject
    ///           SwiftClass 的super是否为空
    func testSubclassExample(){
        
        class People: InitMapping, Serializable{
            var name: String = ""
            var age: Int = 0
            required init(){}
        }
        
        class Student: People{
            var grade: Int = 0
        }


        let studentInfo: [String : AnyObject] = [
            "name" : "Binglin",
            "age" : 18,
            "grade" : 9
        ]
        
        let student = Student(fromDic: studentInfo)
        let serializeStudent = student.toDictionary()
        
        
        
        XCTAssertEqual(student.name, "Binglin")
        XCTAssertEqual(student.age, 18)
        XCTAssertEqual(student.grade, 9)
        
        XCTAssertEqual(studentInfo as NSDictionary, serializeStudent as NSDictionary)
    }
    
}
