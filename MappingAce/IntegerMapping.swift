//
//  IntegerMapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation

protocol NumericalMapping: ValueMapping, Initializable, Updatable {}

extension Bool: NumericalMapping {
    
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.boolValue
        }
        if let str = any as? String{
            
            let lowerCase = str.lowercased()
            
            switch lowerCase {
            case "true": return true
            case "false": return false
            case "0" : return false
            case "1" : return true
            default: break
            }
            
            return self.init(lowerCase)
        }
        return nil
    }
}

extension Int8: NumericalMapping {
    
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.int8Value
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}

extension Int: NumericalMapping {
    
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.intValue
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}

extension UInt8: NumericalMapping {
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.uint8Value
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}

extension Int16: NumericalMapping {
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.int16Value
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}

extension UInt16: NumericalMapping {
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.uint16Value
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}

extension Int32: NumericalMapping {
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.int32Value
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}

extension UInt32: NumericalMapping {
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.uint32Value
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}

extension Int64: NumericalMapping {
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.int64Value
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}

extension UInt64: NumericalMapping {
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.uint64Value
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}

extension Float: NumericalMapping{
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.floatValue
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}

extension Double: NumericalMapping{
    
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue.doubleValue
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
}
