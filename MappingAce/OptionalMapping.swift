//
//  OptionalMapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation


extension Optional: ValueMapping{
    
    public static func mappingWith(any: Any?) -> Any? {
        
        if let value = any{
            
            if let type = Wrapped.self as? ValueMapping.Type{
                return type.mappingWith(value)
            }
        }
        return nil
    }
    
    public func serializedValue() -> Any? {
        
        guard let r = self else{
            return nil
        }
        
        if let mapping = r as? ValueMapping{
            return mapping.serializedValue()
        }
        
        return r
    }
}

extension Optional: Initializable{
    
    public static func initialize(pointer: UnsafeMutablePointer<UInt8>, offset: Int, value: Any?){
        
        let p = pointer.advancedBy(offset)
        let mapped = self.mappingWith(value)
        let bind: UnsafeMutablePointer<Optional<Wrapped>> = UnsafeMutablePointer(p)
        bind.initialize(mapped as? Wrapped)
    }
}

extension Optional: Updatable{
    
    public static func update(pointer: UnsafeMutablePointer<UInt8>, offset: Int, value: Any?){
        let p = pointer.advancedBy(offset)
        let mapped = self.mappingWith(value)
        
        let bind: UnsafeMutablePointer<Optional<Wrapped>> = UnsafeMutablePointer(p)
        bind.memory = mapped as? Wrapped
    }
}
