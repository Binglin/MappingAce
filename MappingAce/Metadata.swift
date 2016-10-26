//
//  Metadata.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/19.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation


struct Metadata {
    var pointer: UnsafePointer<Int>
}

struct Struct {
    var kind: Int
    var nominalTypeDescriptorOffset: Int
    var parent: Metadata?
}



typealias FieldsTypeAccessor = @convention(c) (UnsafePointer<Int>) -> UnsafePointer<UnsafePointer<Int>>


struct NominalTypeDescriptor{
    
    var name: Int32
    var numberOfFields: Int32
    var FieldOffsetVectorOffset: Int32
    var fieldNames: Int32
    var getFieldTypes: Int32
}

extension NominalTypeDescriptor{
   
    struct Class {
        var isa: UnsafePointer<Class>
        var super_: UnsafePointer<Class>
        var reserve1: Int
        var reserve2: Int
        
        var Data: Int
        var classFlags: Int32
        
        var instanceAdressPointer: Int32
        var instanceSize: Int32
        
        var instanceAlignMask: Int16
        var runtime_reserved: Int16
        
        var classobjectsize: Int32
        var classObjectAdressPointer: Int32
        
        // **offset 8** on a 64-bit platform or **offset 11** on a 32-bit platform.
        var Description : Int
        
        static var nominalTypeOffset: Int{
            return (MemoryLayout<Int>.size == MemoryLayout<Int64>.size) ? 8 : 11
        }
    }
}

extension NominalTypeDescriptor{
    
    struct Struct {
        var name: Int32
        var numberOfFields: Int32
        var FieldOffsetVectorOffset: Int32
        var fieldNames: Int32
        var getFieldTypes: Int32
        static var nominalTypeOffset: Int{
            return 1
        }
    }
}

extension NominalTypeDescriptor{
    
    struct Enum {
        var name: Int32
        var NumPayloadCasesAndPayloadSizeOffset: Int32
        var NumEmptyCases: Int32
        var caseNames: Int32
        var getCaseTypes: Int32
    }
}


