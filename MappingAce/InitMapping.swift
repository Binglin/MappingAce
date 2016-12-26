//
//  InitMapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation


public protocol InitMapping: ValueMapping, Updatable, Serializable {
    // should be implement
    init()
    // default implemented
    init(fromDic: [String : Any])
}

public extension InitMapping{
    public init(fromDic d: [String : Any]){
        var item = Self.init()
        item.mapFrom(d)
        self = item
    }
}

extension InitMapping{

    public static func mappingWith(any: Any?) -> Any?{
        guard let v = any as? [String : Any] else{
            return nil
        }
        return Self.init(fromDic: v)
    }
    
    public func serializedValue() -> Any?{
        return self.toDictionary()
    }
    
    private mutating func mapFrom(dic: [String : Any]){
        
        let structInfo = MetadataInfoFor(Self.self)
        
        if structInfo.kind == .`class` {
            
            let opaquePointer = Unmanaged.passUnretained(self as! AnyObject).toOpaque()
            self.updateValue(rawPointer: opaquePointer, withDic: dic, structInfo: structInfo)
        }
        //structInfo.kind == .struct
        else{
            
            let selfPointer = withUnsafePointer(&self, {$0})
            let p = UnsafeMutablePointer(selfPointer)
            self.updateValue(rawPointer: p, withDic: dic, structInfo: structInfo)
        }
    }
    
    private func updateValue(rawPointer p: UnsafeMutablePointer, withDic dic: [String : Any], structInfo: ObjectMetadata){
       
        for i in 0..<structInfo.propertyNames.count{
            
            let pName = structInfo.propertyNames[i]
            let pType = structInfo.propertyTypes[i]
            let pOffs = structInfo.propertyOffsets[i]
            
            let dicValue = valueFor(pName, fromDic: dic, type: Self.self)
                //dic[pName]
            
            if !(pType is ExpressibleByNilLiteral.Type) && dicValue == nil{
                continue
            }
            
            guard let type = pType as? Updatable.Type else{
                fatalError("not implemented for update value after init")
            }
            
            
            if let value = dicValue{
               type.update(pointer: p, offset: pOffs, value: value)
            }
        }
    }
}
