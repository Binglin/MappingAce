//
//  Serializable.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/25.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation

public protocol Serializable{
    func toDictionary() -> [String : Any]
    func toNullableValueDictionary() -> [String : Any?]
}

public extension Serializable{
    
    func toDictionary() -> [String : Any]{
       
        let structInfo = MetadataInfoFor(type: Self.self)
        
        var rawPointer: UnsafeRawPointer
        
        if structInfo.kind == .struct{
            var toSerialize = self
            let selfPointer = withUnsafePointer(to: &toSerialize, {$0})
            rawPointer  = UnsafeRawPointer(selfPointer)
        }else{
            let opaquePointer = Unmanaged.passUnretained(self as AnyObject).toOpaque()
            rawPointer = unsafeBitCast(opaquePointer, to: UnsafeRawPointer.self)
        }
        
        
        var result = [String : Any]()
        
        for i in 0..<structInfo.propertyNames.count{
            
            let pName = structInfo.propertyNames[i]
            let poffs = structInfo.propertyOffsets[i]
            let pType = structInfo.propertyTypes[i]
            
            if let type = pType as? ValueMapping.Type{
                let currentPointer = rawPointer.advanced(by: poffs)
                if let value = type.fetchValue(fromPointer: currentPointer){
                    result.updateValue(value, forKey: pName)
                }
            }else{
                fatalError("not implement for serialize for type: \(pType)")
            }
            
        }
        return result
    }
    
    func toNullableValueDictionary() -> [String : Any?]{
        
        let structInfo = MetadataInfoFor(type: Self.self)
        
        var rawPointer: UnsafeRawPointer
        
        if structInfo.kind == .struct{
            var toSerialize = self
            let selfPointer = withUnsafePointer(to: &toSerialize, {$0})
            rawPointer  = UnsafeRawPointer(selfPointer)
        }else{
            let opaquePointer = Unmanaged.passUnretained(self as AnyObject).toOpaque()
            rawPointer = unsafeBitCast(opaquePointer, to: UnsafeRawPointer.self)
        }
        
        var result = [String : Any?]()
        
        for i in 0..<structInfo.propertyNames.count{
            
            let pName = structInfo.propertyNames[i]
            let poffs = structInfo.propertyOffsets[i]
            let pType = structInfo.propertyTypes[i]
            
            if let type = pType as? ValueMapping.Type{
                let currentPointer = rawPointer.advanced(by: poffs)
                let value = type.fetchValue(fromPointer: currentPointer)
                result.updateValue(value, forKey: pName)
            }else{
                fatalError("not implement for serialize for type: \(pType)")
            }
            
        }
        return result
    }
}
