//
//  EnumIntMapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation



public protocol EnumInt: ValueMapping, Initializable, Updatable {
    init?(rawValue: Int)
    var rawValue: Int { get }
}



extension EnumInt {
    
    public static func mappingWith(any: Any?) -> Any? {
        if let int = any as? Int{
            return Self.init(rawValue: int)
        }
        if let intStr = any as? String{
            let int = Int(intStr)
            return Self.init(rawValue: int!)
        }
        return nil
    }
    
    public func serializedValue() -> Any? {
        return self.rawValue
    }
}
