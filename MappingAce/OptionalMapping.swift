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
                return type.mappingWith(any: value)
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
    
    public static func initialize(pointer: UnsafeMutableRawPointer, offset: Int, value: Any?){
        
        let p = pointer.advanced(by: offset)
        let mapped = self.mappingWith(any: value)
        
        let bind = p.bindMemory(to: Optional<Wrapped>.self, capacity: 1)
        bind.initialize(to: mapped as? Wrapped)
    }
}

extension Optional: Updatable{
    
    public static func update(pointer: UnsafeMutableRawPointer, offset: Int, value: Any?){
        let p = pointer.advanced(by: offset)
        let mapped = self.mappingWith(any: value)
        
        let bind = p.bindMemory(to: Optional<Wrapped>.self, capacity: 1)
        bind.pointee = mapped as? Wrapped
    }
}
