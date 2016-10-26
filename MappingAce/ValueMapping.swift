 //
//  ValueMapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation



public protocol ValueMapping{
    
    /** 
     do some type mapping  such as When int implement this protocol
     this could do some work to deal some special type data
     
     eg: Int: ValueMapping{}
    
     public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue as! Self
        }
            if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
    */
    static func mappingWith(any: Any?) -> Any?
    
    /// no need to override fetchValue(fromPointer:), just override func serializedValue() -> Any?
    static func fetchValue(fromPointer p: UnsafeRawPointer) -> Any?
    
    /// override point if needed
    func serializedValue() -> Any?
}

public extension ValueMapping{
    
    public static func fetchValue(fromPointer p: UnsafeRawPointer) -> Any?{
        let result = p.load(as: Self.self)
        return result.serializedValue()
    }
    
    public func serializedValue() -> Any?{
        return self
    }
}
