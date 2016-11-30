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
    
    
    /// fetch value from pointer as Self
    ///
    /// - Parameter p: pointer
    /// - Returns:     value of Self.type
    static func fetchValue(fromPointer p: UnsafeRawPointer) -> Any?
    
    /// override point if needed
    /// value when convert to json object
    ///
    /// - Returns: json
    func serializedValue() -> Any?
}

public extension ValueMapping{
    
    
    /// fetch value from pointer
    ///
    /// - Parameter p: pointer
    /// - Returns:     value from serializedValue of Self.Type
    public static func fetchValue(fromPointer p: UnsafeRawPointer) -> Any?{
        let result = p.load(as: Self.self)
        return result.serializedValue()
    }
    
    
    /// value when convert to json object
    ///
    /// - Returns: json
    public func serializedValue() -> Any?{
        return self
    }
}
