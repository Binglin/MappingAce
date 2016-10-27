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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        struct UserArrayPhoneEntity: Mapping{
            var age: Int?
            var name: String?
            var phone: PhoneNumber
            var phones: [PhoneNumber]
        }
        
        struct PhoneNumber: Mapping {
            var tel: String
            var type: String
        }
        
        
        let phone: [String : Any] = [
            "tel": "186xxxxxxxx",
            "type": "work"
        ]
        
        let phones = Array.init(count: 10, repeatedValue: phone)
        let dic: [String : Any] = [
            "age" : 14.0,
            "name": "Binglin",
            "phone": phone,
            "phones": phones
        ]
        
        for _ in 0..<150{
//            DispatchQueue.global().async {
            let user = UserArrayPhoneEntity.init(fromDic: dic)
            print(user)
//            }
        }
        
    }
}




