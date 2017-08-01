//
//  PerformanceTests.swift
//  Mapping
//
//  Created by ET|冰琳 on 2017/2/17.
//  Copyright © 2017年 Ice Butterfly. All rights reserved.
//

import XCTest
@testable import MappingAce
@testable import Unbox
@testable import ObjectMapper
@testable import SwiftyJSON


struct PhoneNumberInPerformance: Mapping, Mappable {
    var tel: String?
    var type: String?
    
    init?(map: Map) {
        self.tel <- map["tel"]
        self.type <- map["type"]
    }
    
    mutating func mapping(map: Map) {
       
    }
    
    init(tel: String?, type: String?) {
        self.tel = tel
        self.type = type
    }
}

extension PhoneNumberInPerformance: Unboxable {
    init(unboxer: Unboxer) throws {
        self.tel = unboxer.unbox(key: "tel")
        self.type = unboxer.unbox(key: "type")
    }
}

struct UserInPerformance: Mapping, Mappable, Unboxable{
    var age: Int?
    var name: String?
    var phone: PhoneNumberInPerformance?
    
    
    
    init(age: Int?, name: String?, phone: PhoneNumberInPerformance?) {
        self.age = age
        self.name = name
        self.phone = phone
    }
    
    // MARK: - Mappable
    init?(map: Map) {
        self.age <- map["age"]
        self.name <- map["name"]
        self.phone <- map["phone"]
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    // unbox
    init(unboxer: Unboxer) throws {
        self.age = unboxer.unbox(key: "age")
        self.name = unboxer.unbox(key: "name")
        self.phone = unboxer.unbox(key: "phone")
    }

}


class PerformanceTests: XCTestCase {
    
    
    let dic: [String : Any] = [
        "age" : "24",
        "name": "Binglin",
        "phone": [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
    ]
    
    
    func testMappingAcePerformanceExample() {
        
        self.measure {
            for _ in 0..<10000{
                _ = UserInPerformance(fromDic: self.dic)
            }
        }
    }

    func testHardCodePerformanceExample() {
        
        self.measure {
            
            for _ in 0..<10000{
                
                var user = UserInPerformance.init(age: nil, name: nil, phone: nil)
                var phone = PhoneNumberInPerformance.init(tel: nil, type: nil)
                
                if let name = self.dic["name"] as? String {
                    user.name = name
                }
                if let age = self.dic["age"]  as? Int {
                    user.age = age
                }
                
                let phoneInfo = self.dic["phone"] as? [String : Any]
                
                if let phonetel = phoneInfo?["tel"] as? String {
                    phone.tel = phonetel
                }
                
                if let phoneType = phoneInfo?["type"] as? String {
                    phone.type = phoneType
                }
                user.phone = phone
            }
        }
    }
    
    func testSwiftyJSONPerformanceExample() {
        
        self.measure {
            
            for _ in 0..<10000{
                
                let json = JSON.init(self.dic)
                
                var user = UserInPerformance.init(age: nil, name: nil, phone: nil)
                var phone = PhoneNumberInPerformance.init(tel: nil, type: nil)
                
                if let age = json["age"].int {
                    user.age = age
                }
                
                if let name = json["name"].string {
                    user.name = name
                }
                
                if let phoneNum = json["phone"]["tel"].string {
                    phone.tel = phoneNum
                }
                
                if let type = json["phone"]["type"].string {
                    phone.type = type
                }
                user.phone = phone
                
            }
        }
    }
    
    func testObjectMapperPerformanceExample() {
        
        self.measure {
            
            for _ in 0..<10000{
                _ = UserInPerformance(map: Map.init(mappingType: MappingType.fromJSON, JSON: self.dic))
            }
        }
    }

    func testUnboxPerformanceExample() {
        
        self.measure {
            
            do {
                for _ in 0..<10000{
                    let _: UserInPerformance = try unbox(dictionary: self.dic)
                }
            }catch {
                
            }
        }
    }
}
