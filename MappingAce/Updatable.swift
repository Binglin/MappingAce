//
//  Updatable.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/25.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation


public protocol Updatable {
    static func update(pointer: UnsafeMutableRawPointer, offset: Int, value: Any?)
}

public extension Updatable where Self: ValueMapping{
    
    public static func update(pointer: UnsafeMutableRawPointer, offset: Int, value: Any?){
        let mapped = self.mappingWith(any: value)
        let p = pointer.advanced(by: offset)
        let bind = p.bindMemory(to: Self.self, capacity: 1)
        
        bind.pointee = mapped as! Self
    }
}
