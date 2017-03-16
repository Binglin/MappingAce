//
//  ViewController.swift
//  Mapping
//
//  Created by 郑林琴 on 16/10/10.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import UIKit
import MappingAce

class ViewController: UIViewController {

    struct PhoneNumber: Mapping {
        var tel: String
        var type: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testStructMapping()
        self.testStructMappingWithDefaultValue()
    }
    
    
    func testStructMapping(){
        
        struct UserArrayPhoneEntity: Mapping{
            var age: Int?
            var name: String?
            var phone: PhoneNumber
            var phones: [PhoneNumber]
        }
        
        
        let phone: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let phones = Array(repeating: phone, count: 10)
        let dic: [String : Any] = [
            "age" : 14.0,
            "name": "Binglin",
            "phone": phone,
            "phones": phones
        ]
        
        let user = UserArrayPhoneEntity(fromDic: dic)
        
        let serialized = user.toDictionary()
            
        print(serialized)
        
    }
    
    func testStructMappingWithDefaultValue(){
        
        struct UserArrayPhoneEntity: InitMapping{
            var age: Int?
            var name: String = "default"
            var phone: PhoneNumber?
            var phones: [PhoneNumber] = []
        }
        
        struct PhoneNumber: Mapping {
            var tel: String
            var type: String
        }
        
        
        let phone: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "Work"
        ]
        
        let phones = Array(repeating: phone, count: 10)
        let dic: [String : Any] = [
            "age" : 14.0,
            "phone": phone,
            "phones": phones
        ]

        let user = UserArrayPhoneEntity(fromDic: dic)
        let serialized = user.toDictionary()
        print(serialized)

    }
    
    
}




