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

    init(data: NSData , options: NSJSONReadingOptions = .AllowFragments) throws{        
        let jsonDic = try NSJSONSerialization.JSONObjectWithData(data, options: options)
        let dic = jsonDic as! [String : Any]
        self = Self.init(fromDic: dic)
    }
}

public extension Mapping{
   
    init(fromDic dic: [String : Any]){
        self = MappingAny(Self.self, fromDic: dic)
    }

}

extension Mapping{
    static func initialize(pointer: UnsafeMutablePointer<UInt8>, offset: Int, value: Any?){
        let mapped = self.mappingWith(value)
        let selfPointer: UnsafeMutablePointer<Self> = UnsafeMutablePointer(pointer.advancedBy(offset))
        selfPointer.memory = mapped as! Self
    }
    
    func serializedValue() -> Any?{
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
    
    let phone = UnsafeMutablePointer<T>.alloc(1)
    defer {
        phone.dealloc(1)
    }
    let rawPhone: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer(phone)
    
    let structInfo = MetadataInfoFor(T.self)
    
    if structInfo.kind != .`struct`{
        fatalError("class should be implement InitMapping")
    }
    
    for i in 0..<structInfo.propertyNames.count{
        
        let pName = structInfo.propertyNames[i]
        let pType = structInfo.propertyTypes[i]
        let pOffs = structInfo.propertyOffsets[i]
        
        let dicValue = valueFor(pName, fromDic: dic, type: T.self)//dic[pName]
        
        
        if !(pType is NilLiteralConvertible.Type) && dicValue == nil{
            let msg = "\n⚡️\(String(T.self))⚡️ missing required value for property 💔 \(pName) 💔\n"
            print(msg)
            fatalError(msg)
        }
        
        if let type = pType as? Initializable.Type{
            type.initialize(rawPhone, offset: pOffs, value: dicValue)
        }else{
            fatalError("not implement type \(pType) for initializable")
        }
    }
    
    
    return phone.memory
}
