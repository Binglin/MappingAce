//
//  Serializable.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/25.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation

public protocol Serializable{
    func toDictionary() -> [String : AnyObject]
    func toNullableValueDictionary() -> [String : AnyObject?]
}

public extension Serializable{
    
    func toDictionary() -> [String : AnyObject]{
       
        let structInfo = MetadataInfoFor(Self.self)
        
        var rawPointer: UnsafeMutablePointer<UInt8>
        
        if structInfo.kind == .`struct`{
            var toSerialize = self
            let selfPointer = withUnsafePointer(&toSerialize, {$0})
            rawPointer  = UnsafeMutablePointer(selfPointer)
        }else{
            let opaquePointer = Unmanaged.passUnretained(self as! AnyObject).toOpaque()
            rawPointer = UnsafeMutablePointer(opaquePointer)
        }
        
        
        var result = [String : AnyObject]()
        
        for i in 0..<structInfo.propertyNames.count{
            
            let pName = structInfo.propertyNames[i]
            let poffs = structInfo.propertyOffsets[i]
            let pType = structInfo.propertyTypes[i]
            
            if let type = pType as? ValueMapping.Type{
                let currentPointer = rawPointer.advancedBy(poffs)
                if let value = type.fetchValue(fromPointer: currentPointer){
                    result.updateValue(value as! AnyObject, forKey: pName)
                }
            }else{
                fatalError("not implement for serialize for type: \(pType)")
            }
            
        }
        return result
    }
    
    func toNullableValueDictionary() -> [String : AnyObject?]{
        
        let structInfo = MetadataInfoFor(Self.self)
        
        var rawPointer: UnsafeMutablePointer<UInt8>
        
        if structInfo.kind == .`struct`{
            var toSerialize = self
            let selfPointer = withUnsafePointer(&toSerialize, {$0})
            rawPointer  = UnsafeMutablePointer(selfPointer)
        }else{
            let opaquePointer = Unmanaged.passUnretained(self as! AnyObject).toOpaque()
            rawPointer = UnsafeMutablePointer(opaquePointer)
        }
        
        var result = [String : AnyObject?]()
        
        for i in 0..<structInfo.propertyNames.count{
            
            let pName = structInfo.propertyNames[i]
            let poffs = structInfo.propertyOffsets[i]
            let pType = structInfo.propertyTypes[i]
            
            if let type = pType as? ValueMapping.Type{
                let currentPointer = rawPointer.advancedBy(poffs)
                let value = type.fetchValue(fromPointer: currentPointer)
                result.updateValue(value as! AnyObject, forKey: pName)
            }else{
                fatalError("not implement for serialize for type: \(pType)")
            }
            
        }
        return result
    }
}
