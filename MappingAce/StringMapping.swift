//
//  StringMapping.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/24.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation


extension String: ValueMapping{
    public static func mappingWith(any: Any?) -> Any? {
        if let any = any{
            if any is NSNull {
                return nil
            }
            return String(describing: any)
        }
        return nil
    }
}

extension String: Initializable{}
extension String: Updatable{}
