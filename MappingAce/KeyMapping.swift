//
//  KeyMapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation


protocol KeyMapping {
    static func mappedKeyFor(key: String) -> String?
}



/// 从字段里获取对应key的值
///
/// - parameter propertyName: property name write in entity
/// - parameter d:            dic to get property value from
/// - parameter type:
///
/// - returns:
func valueFor(propertyName: String, fromDic d: [String : Any], type: Any.Type) -> Any?{
    
    if let value = valueFor(propertyName, fromDic: d){
        return value
    }
    
    /// 如果没有key映射 或者无对应key映射的值
    guard let t = type as? KeyMapping.Type , let mappedKey = t.mappedKeyFor(propertyName) else{
        return nil
    }
    
    /// 有key映射值
    return valueFor(mappedKey, fromDic: d)
}

func valueFor(keyPath: String, fromDic d: [String : Any]) -> Any? {
    
    /// key
    let value = d[keyPath]
    if let value = value{
        return value
    }
    
    /// keyPath
    let seperatedStr = keyPath.componentsSeparatedByString(".")
    
    if seperatedStr.count > 1 {
        
        var returnValue: Any? = d
        
        for key in seperatedStr{
            returnValue = (returnValue as? [String : Any])?[key]
        }
        return returnValue
    }
    return nil
}
