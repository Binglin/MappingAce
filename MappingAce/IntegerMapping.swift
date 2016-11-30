//
//  IntegerMapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation

protocol NumericalMapping: ValueMapping, Initializable, Updatable {
    init?(_ text: String)
}

extension NumericalMapping{
    

}


protocol NumericalRadixMapping{
    init?(_ text: String, radix: Int)
}

extension NumericalMapping where Self: NumericalRadixMapping{
    init?(_ text: String){
        let result = Self.init(text, radix: 10)
        guard let r = result else{
            return nil
        }
        self = r
    }
}



extension Bool: NumericalMapping{
    
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

extension Int8: NumericalMapping, NumericalRadixMapping{
    
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

extension Int: NumericalMapping, NumericalRadixMapping{
    
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

extension UInt8: NumericalMapping, NumericalRadixMapping{
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

extension Int16: NumericalMapping, NumericalRadixMapping{
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

extension UInt16: NumericalMapping, NumericalRadixMapping{
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

extension Int32: NumericalMapping, NumericalRadixMapping{
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

extension UInt32: NumericalMapping, NumericalRadixMapping{
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

extension Int64: NumericalMapping, NumericalRadixMapping{
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

extension UInt64: NumericalMapping, NumericalRadixMapping{
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
