//
//  SwiftStructNonilTests.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import XCTest
@testable import Mapping
@testable import MappingAce

private struct User: Mapping{
    var age: Int
    var name: String
    var phone: PhoneNumber
}

private struct PhoneNumber: Mapping {
    var tel: String
    var type: String
}




class SwiftStructNonilTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMappingAny_struct(){
        
        
        struct PhoneEntity {
            var tel: String
            var type: String
        }
        
        let phoneInfo: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let phone = MappingAny(type: PhoneEntity.self, fromDic: phoneInfo)
        
        XCTAssertEqual(phone.tel, "186xxxxxxxx")
        XCTAssertEqual(phone.type, "work")
        
    }
    
    func testStructMapping(){
        
        let phoneInfo: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let phone = PhoneNumber(fromDic: phoneInfo)
        let dic =  phone.toDictionary()
        
        print(dic)
        XCTAssertEqual(dic as NSDictionary, phoneInfo as NSDictionary)
        
        XCTAssertEqual(phone.tel, "186xxxxxxxx")
        XCTAssertEqual(phone.type, "work")
    }
    
    func testEmbedMappingExample() {
        
        let phone: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let dic: [String : Any] = [
            "age" : 24,
            "name": "Binglin",
            "phone": phone
        ]
        
        let user = MappingAny(type: User.self, fromDic: dic)
        let userDic  = user.toDictionary()
        
        XCTAssertEqual(dic as NSDictionary, userDic as NSDictionary)
        
        XCTAssertEqual(user.age, 24)
        XCTAssertEqual(user.name, "Binglin")
        XCTAssertEqual(user.phone.tel, "186xxxxxxxx")
        XCTAssertEqual(user.phone.type, "work")
    }
    
    func testStringToIntExample() {
        
        let phone: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let dic: [String : Any] = [
            "age" : "24",
            "name": "Binglin",
            "phone": phone
        ]
        
        let user = MappingAny(type: User.self, fromDic: dic)
        
        XCTAssertEqual(user.age, 24)
        XCTAssertEqual(user.name, "Binglin")
        XCTAssertEqual(user.phone.tel, "186xxxxxxxx")
        XCTAssertEqual(user.phone.type, "work")
    }
    
    func testEnumIntExample(){
        
        enum Gender: Int, EnumInt{
            case male = 1
            case female = 2
        }
        
        struct User: Mapping, Serializable{
            var name: String
            var gender: Gender
        }
        
        
        let dicGender1: [String : Any] = [
            "name": "Binglin",
            "gender": 1
        ]
        
        let dicGender2: [String : Any] = [
            "name": "Binglin",
            "gender": 2
        ]
        
        let userMale = User(fromDic: dicGender1)
        let userFemale = User(fromDic: dicGender2)
        
        XCTAssertEqual(userMale.name, "Binglin")
        XCTAssertEqual(userFemale.name, "Binglin")
        XCTAssertEqual(userMale.gender, Gender.male)
        XCTAssertEqual(userFemale.gender, Gender.female)
        
        XCTAssertEqual(userMale.toDictionary() as NSDictionary, dicGender1 as NSDictionary)
        XCTAssertEqual(userFemale.toDictionary() as NSDictionary, dicGender2 as NSDictionary)
        
    }
    
    
    func testEnumStringExample(){
        
        enum Gender: String, EnumString{
            case male = "m"
            case female = "f"
        }
        
        struct User: Mapping{
            var name: String
            var gender: Gender
        }
        
        
        let dicGender1: [String : Any] = [
            "name": "Binglin",
            "gender": "m"
        ]
        
        let dicGender2: [String : Any] = [
            "name": "Binglin",
            "gender": "f"
        ]
        
        let userMale = User(fromDic: dicGender1)
        let userFemale = User(fromDic: dicGender2)
        
        XCTAssertEqual(userMale.name, "Binglin")
        XCTAssertEqual(userFemale.name, "Binglin")
        XCTAssertEqual(userMale.gender, Gender.male)
        XCTAssertEqual(userFemale.gender, Gender.female)
        
    }
    
    func testInitMappintExample(){
        
        struct User: InitMapping{
            var name = "default"
            var age  = 24
        }
        
        
        let dic: [String : Any] = ["name" : "Binglin"]
        let user = User(fromDic: dic)
        
        
        
        XCTAssertEqual(user.name, "Binglin")
        XCTAssertEqual(user.age, 24)
        
    }
    
    func testKeyMappingExample(){
        
        struct User: Mapping, KeyMapping{
            var name: String
            var avator: String
            
            static func mappedKeyFor(key: String) -> String?{
                switch key {
                case "avator":  return "headURL"
                default:        return nil
                }
            }
        }
        
        let dic: [String : Any] = ["name" : "Binglin", "headURL" : "www.xxx.com"]
        
        let user = User(fromDic: dic)
        
        XCTAssertEqual(user.name, "Binglin")
        XCTAssertEqual(user.avator, "www.xxx.com")
    }
    
    func testArrayMappingExample(){
        
        let v = Optional<Bool>.none.serializedValue()
        //XCTAssertEqual(v, nil)
        
        struct UserArrayPhoneEntity: Mapping{
            var age: Int
            var name: String
            var phones: [PhoneNumber]
            var phonesArr : [[PhoneNumber]]
            var phonesArrS : [[[PhoneNumber]]]
        }
        
        
        let phone: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let phones = Array(repeating: phone, count: 10)
        let dic: [String : Any] = [
            "age" : 24,
            "name": "Binglin",
            "phones": phones,
            "phonesArr" : [phones, phones],
            "phonesArrS" : [[phones, phones]]
        ]
        
        let user = UserArrayPhoneEntity.init(fromDic: dic)
        let serializedUser = user.toDictionary()
        
        XCTAssertEqual(dic as NSDictionary, serializedUser as NSDictionary)
        
        XCTAssertEqual(user.phones.count, 10)
        XCTAssertEqual(user.phones[0].type, "work")
    }
    
    func testArrayInitMappingExample(){
        
        struct UserArrayPhoneEntity: InitMapping{
            var age: Int = 0
            var name: String = ""
            var phones: [PhoneNumber] = []
        }
        
        
        let phone: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let phones = Array(repeating: phone, count: 10)
        let dic: [String : Any] = [
            "age" : 24,
            "name": "Binglin",
            "phones": phones
        ]
        
        let user = UserArrayPhoneEntity.init(fromDic: dic)
        let dicArr = user.toDictionary()
        
        XCTAssertEqual(dic as NSDictionary, dicArr as NSDictionary)
        
        XCTAssertEqual(user.phones.count, 10)
        XCTAssertEqual(user.phones[0].type, "work")
    }
    
    
    func testEntityInitMappingExample(){
        
        
        struct PhoneNumber: Mapping {
            var tel: String
            var type: String
        }
        
        struct UserArrayPhoneEntity: InitMapping{
            var age: Int = 0
            var name: String = ""
            var phone: PhoneNumber = PhoneNumber(tel: "", type: "")
        }
        
        
        let phone: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let dic: [String : Any] = [
            "age" : "24",
            "name": "Binglin",
            "phone": phone
        ]
        
        let user = UserArrayPhoneEntity.init(fromDic: dic)
        
        XCTAssertEqual(user.phone.tel, "186xxxxxxxx")
        XCTAssertEqual(user.phone.type, "work")
    }
    
    
    func testNumericalExample(){
        
        struct Numerical: Mapping{
            
            var bool : Bool
            var int: Int
            var int8 : Int8
            
            var float: Float
            var double: Double
            
            var timeInterval: TimeInterval
        }
        
        
        let numericalSet: [String : Any] = [
            "bool": "true",
            "int": "5",
            "int8": "1",
            "float": 1.99,
            "double": 3.14,
            "timeInterval": 12345
        ]
        
        let num = Numerical.init(fromDic: numericalSet)
        XCTAssertEqual(num.bool, true)
        XCTAssertEqual(num.int, 5)
        XCTAssertEqual(num.int8, 1)
        XCTAssertEqual(num.float, 1.99)
        XCTAssertEqual(num.double, 3.14)
        XCTAssertEqual(num.timeInterval, 12345)
        
    }
    
    func testKeyPathMapping(){
        
        struct A: KeyMapping{
            var int: Int
            
            fileprivate static func mappedKeyFor(key: String) -> String? {
                if key == "int" {
                    return "a.b.c"
                }
                return nil
            }
        }
        
        let dic : [String : Any] = ["a" : ["b": ["c": 1]]]
        let keyPathA = MappingAny(type: A.self, fromDic: dic)
        
        XCTAssertEqual(keyPathA.int, 1)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        
        let phone: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let dic: [String : Any] = [
            "age" : "24",
            "name": "Binglin",
            "phone": phone
        ]
        
        self.measure {
            for _ in 0..<10000{
                _ = MappingAny(type: User.self, fromDic: dic)
            }
        }
    }
    
    func testRawSetPerformanceExample() {
        // This is an example of a performance test case.
        
        let phone: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let dic: [String : Any] = [
            "age" : "24",
            "name": "Binglin",
            "phone": phone
        ]
        
        
        self.measure {
            
            for _ in 0..<10000{
                
                let name = dic["name"] as! String
                let age  = dic["age"]
                let phoneInfo = dic["phone"] as? [String : Any]
                
                let phonetel = phoneInfo?["tel"] as! String
                let phoneType     = phoneInfo?["type"] as! String
                if let age = age as? Int{
                    let phoneModel = PhoneNumber(tel: phonetel, type: phoneType)
                    _ = User(age: age, name: name, phone: phoneModel)
                }else if let agestr = age as? String{
                    let ageint = Int.init(agestr)!
                    let phoneModel = PhoneNumber(tel: phonetel, type: phoneType)
                    _ = User(age: ageint, name: name, phone: phoneModel)
                }
            }
        }
    }
    
}



