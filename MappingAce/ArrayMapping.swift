//
//  ArrayMapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation


extension Array: ValueMapping{
    
    public static func mappingWith(any: Any?) -> Any?{
        
        if let elementType = Element.self as? ValueMapping.Type , let value = any as? [Any]{
            
            var result = [Element]()
            for i in 0..<value.count{
                result.append(elementType.mappingWith(value[i]) as! Element)
            }
            return result
            
        }
        return any
    }
    

}

extension Array where Element: ValueMapping{
    
    public func serializedValue() -> Any? {
        
        var result = [Any]()
        for i in 0..<self.count{
            if let serialized = self[i].serializedValue(){
                result.append(serialized)
            }
        }
        if result.count > 0{
            return result
        }
        return nil
    }
}

extension Array: Initializable{
    
    public static func initialize(pointer: UnsafeMutablePointer<UInt8>, offset: Int, value: Any?){
        
        let p = pointer.advancedBy(offset)
        let bind = unsafeBitCast(p, UnsafeMutablePointer<[Element]>.self)
        
        if let value = self.mappingWith(value) as? [Element]{
            bind.initialize(value)
        }
        else{
            bind.initialize([])
        }
    }
}

extension Array: Updatable{}
    
