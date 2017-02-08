//
//  Mapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/20.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation


/// Mark: - Mapping
public protocol Mapping: ValueMapping, Initializable, Updatable, Serializable{
    init(fromDic: [String : Any])
}

public extension Mapping{

    init(data: Data , options: JSONSerialization.ReadingOptions = .allowFragments) throws{
        let jsonDic = try JSONSerialization.jsonObject(with: data, options: options)
        let dic = jsonDic as! [String : Any]
        self = Self.init(fromDic: dic)
    }
}

public extension Mapping{
   
    init(fromDic dic: [String : Any]){
        self = MappingAny(type: Self.self, fromDic: dic)
    }

}

extension Mapping{
    public static func initialize(pointer: UnsafeMutableRawPointer, offset: Int, value: Any?){
        let mapped = self.mappingWith(any: value)
        pointer.storeBytes(of: mapped as! Self, toByteOffset: offset, as: Self.self)
    }
    
    public func serializedValue() -> Any?{
        return self.toDictionary()
    }

}


extension Mapping{

    public static func mappingWith(any: Any?) -> Any?{
        guard let input = any as? [String : Any] else { return nil }
        return self.init(fromDic: input)
    }
}


/// Mark: - MappingAny


public func MappingAny<T>(type: T.Type = T.self, fromDic dic: [String : Any]) -> T{
    
    let phone = UnsafeMutablePointer<T>.allocate(capacity: 1)
    defer {
        phone.deallocate(capacity: 1)
    }
    let rawPhone = UnsafeMutableRawPointer(phone)
    
    let structInfo = MetadataInfoFor(type: T.self)
    
    if structInfo.kind != .struct{
        fatalError("class should be implement InitMapping")
    }
    
    for i in 0..<structInfo.propertyNames.count{
        
        let pName = structInfo.propertyNames[i]
        let pType = structInfo.propertyTypes[i]
        let pOffs = structInfo.propertyOffsets[i]
        
        var dicValue = valueFor(propertyName: pName, fromDic: dic, type: T.self)//dic[pName]
        
        
        if !(pType is ExpressibleByNilLiteral.Type) && dicValue == nil{
            let msg = "\n⚡️\(String(describing: T.self))⚡️ missing required value for property 💔 \(pName) 💔\n"
            print(msg)
            fatalError(msg)
        }
        
        if dicValue is NSNull {
            dicValue = nil
        }
        
        if let type = pType as? Initializable.Type{
            type.initialize(pointer: rawPhone, offset: pOffs, value: dicValue)
        }else{
            fatalError("not implement type \(pType) for initializable")
        }
    }
    let result = rawPhone.load(fromByteOffset: 0, as: T.self)
    return result
}
