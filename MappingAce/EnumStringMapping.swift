//
//  EnumStringMapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation



public protocol EnumString: ValueMapping, Initializable, Updatable  {
    init?(rawValue: String)
    var rawValue: String { get }
}

extension EnumString{
    public static func mappingWith(any: Any?) -> Any? {
        if let any = any{
            let str = String(describing: any)
            return Self.init(rawValue: str)
        }
        return nil
    }
    public func serializedValue() -> Any? {
        return self.rawValue
    }
}
