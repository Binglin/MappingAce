//
//  Updatable.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/25.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation


public protocol Updatable {
    static func update(pointer: UnsafeMutablePointer<UInt8>, offset: Int, value: Any?)
}

public extension Updatable where Self: ValueMapping{
    
    public static func update(pointer: UnsafeMutablePointer<UInt8>, offset: Int, value: Any?){
        let mapped = self.mappingWith(value)
        let p = pointer.advancedBy(offset)
        let bind: UnsafeMutablePointer<Self> = UnsafeMutablePointer(p)
        bind.memory = mapped as! Self
    }
}
