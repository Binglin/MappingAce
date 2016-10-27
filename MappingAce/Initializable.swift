//
//  Initializable.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/25.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation

public protocol Initializable {
    static func initialize(pointer: UnsafeMutablePointer<UInt8>, offset: Int, value: Any?)
}

public extension Initializable where Self: ValueMapping{
    
    static func initialize(pointer: UnsafeMutablePointer<UInt8>, offset: Int, value: Any?){
        let mapped = self.mappingWith(value)
        let p: UnsafeMutablePointer<Self> = UnsafeMutablePointer(pointer)
        p.memory = mapped as! Self
    }
}
