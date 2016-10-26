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
    
    public static func mappingWith(any: Any?) -> Any? {
        if let exactValue = any as? NSNumber{
            return exactValue as! Self
        }
        if let intStr = any as? String{
            return self.init(intStr)
        }
        return nil
    }
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
            return exactValue as Bool
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

extension Int8: NumericalMapping, NumericalRadixMapping{}

extension Int: NumericalMapping, NumericalRadixMapping{}

extension UInt8: NumericalMapping, NumericalRadixMapping{}

extension Int16: NumericalMapping, NumericalRadixMapping{}

extension UInt16: NumericalMapping, NumericalRadixMapping{}

extension Int32: NumericalMapping, NumericalRadixMapping{}

extension UInt32: NumericalMapping, NumericalRadixMapping{}

extension Int64: NumericalMapping, NumericalRadixMapping{}

extension UInt64: NumericalMapping, NumericalRadixMapping{}

extension Float: NumericalMapping{}

extension Double: NumericalMapping{}
