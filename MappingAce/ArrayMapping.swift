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
    
    public func serializedValue() -> Any? {
        
        let resultAny: [Any] = self
        
        if let values = resultAny as? [ValueMapping]{
            
            var result = [Any]()
            for i in 0..<self.count{
                if let serialized = values[i].serializedValue(){
                    result.append(serialized)
                }
            }
            if result.count > 0{
                return result
            }
        }
        return resultAny
    }
}

extension Array: Initializable{
    
    public static func initialize(pointer: UnsafeMutablePointer<Int8>, offset: Int, value: Any?){
        
        let p = pointer.advancedBy(offset)
        
        if let value = self.mappingWith(value) as? [Element]{
            let bind = p.bindMemory(to: [Element].self, capacity: 1)
            bind.initialize(to: value)
        }
        else{
            let bind = p.bindMemory(to: [Element].self, capacity: 1)
            bind.initialize(to: [])
        }
    }
}

extension Array: Updatable{}


extension Array where Element: ValueMapping{
    
    public init(JSON: String) throws{
        let jsonData = JSON.dataUsingEncoding(NSUTF8StringEncoding)
        guard let data = jsonData else {
            throw MappingError.nilData
        }
        let jsonObj  = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        
        guard let jsonObjArr = jsonObj as? [[String: Any]] else{
            throw MappingError.jsonInvalidate;
        }
        
        self = jsonObjArr.map{ Element.mappingWith($0) as! Element }
    }
        
    public init(jsonObjArray: [[String : Any]]){
        self = jsonObjArray.map{ Element.mappingWith($0) as! Element }
    }
}
    
