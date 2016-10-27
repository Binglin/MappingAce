//
//  ObjectMetadata.swift
//  Mapping
//
//  Created by ET|冰琳 on 16/10/19.
//  Copyright © 2016年 Ice Butterfly. All rights reserved.
//

import Foundation


enum MetadataKind {
    case `struct`
    case `class`
    case ObjCClassWrapper
}
 
struct ObjectMetadata {
    var kind: MetadataKind
    var propertyNames: [String]
    var propertyTypes: [Any.Type]
    var propertyOffsets: [Int]
}


func MetadataInfoFor(type: Any.Type) -> ObjectMetadata{
    
    let typePointer = unsafeBitCast(type, UnsafePointer<Struct>.self)
    //print(type, "pointer is", typePointer)
    let typeStruct = typePointer.memory
    let kind = typeStruct.kind
    
    let int8P: UnsafePointer<UInt8> = UnsafePointer(typePointer)
    for i in 0..<20{
        print("\(i)", int8P.advancedBy(i).memory)
    }
    
    print(type, "meta info :", typeStruct)
    
    struct TypeInfoHashTable{
        static var table: [UnsafePointer<Struct> : ObjectMetadata] = [:]
    }
    
    if let structInfo = TypeInfoHashTable.table[typePointer]{
        return structInfo
    }

    if kind == 1{
        let info = nominalTypeOfStruct(typePointer)
        TypeInfoHashTable.table[typePointer] = info
        return info
    }
    else if kind == 2{
        fatalError("not implement for enum")
    }else if kind == 14{
        return ObjectMetadata(kind: .ObjCClassWrapper, propertyNames: [], propertyTypes: [], propertyOffsets: [])
    }
    else if kind > 4096{
        let info = nominalTypeOfClass(typePointer: typePointer)
        TypeInfoHashTable.table[typePointer] = info
        return info
    }
    fatalError("not implement type")
}

private func nominalTypeOfStruct(typePointer: UnsafePointer<Struct>) -> ObjectMetadata{
    
    let intPointer: UnsafePointer<Int> = UnsafePointer(typePointer)
    
    let nominalTypeBase = intPointer.advancedBy(1)
    
    let int8Type: UnsafePointer<UInt8> = UnsafePointer(nominalTypeBase)
    
    let nominalTypePointer = int8Type.advancedBy(Int(typePointer.memory.nominalTypeDescriptorOffset))
    
    for i in 0..<20{
        print("\(i)", int8Type.advancedBy(i).memory)
    }
    
    let nominalType: UnsafePointer<NominalTypeDescriptor> = UnsafePointer(nominalTypePointer)
    
    print(nominalType, nominalType.memory)
    
    print(nominalType.memory)
    
    let numberOfField = Int(nominalType.memory.numberOfFields)
    
    
    let int32NominalType = unsafeBitCast(nominalType, UnsafePointer<Int32>.self)
    let fieldBase = int32NominalType.advancedBy(Int(nominalType.memory.FieldOffsetVectorOffset))
    
    let int8FieldBasePointer = unsafeBitCast(fieldBase, UnsafePointer<Int8>.self)
    let fieldNamePointer = int8FieldBasePointer.advancedBy(Int(nominalType.memory.fieldNames))
    
    let fieldNames = getFieldNames(fieldNamePointer, fieldCount: numberOfField)
    
    let int32NominalFunc = unsafeBitCast(nominalType, UnsafePointer<Int32>.self).advancedBy(4)
    let nominalFunc = unsafeBitCast(int32NominalFunc, UnsafePointer<Int8>.self).advancedBy(Int(nominalType.memory.getFieldTypes))
    
    let fieldType = getType(pointer: nominalFunc, fieldCount: numberOfField)
    
    let offsetPointer = intPointer.advancedBy(Int(nominalType.memory.FieldOffsetVectorOffset))
    var offsetArr: [Int] = []
    
    for i in 0..<numberOfField {
        let offset = offsetPointer.advancedBy(i)
        offsetArr.append(offset.memory)
    }
    
    let info = ObjectMetadata(kind: .`struct`,propertyNames: fieldNames, propertyTypes: fieldType, propertyOffsets: offsetArr)
    return info
}

 

private func getType(pointer nominalFunc: UnsafePointer<Int8>, fieldCount numberOfField: Int) -> [Any.Type]{
        
    let funcPointer = unsafeBitCast(nominalFunc, FieldsTypeAccessor.self)
    let funcBase = funcPointer(unsafeBitCast(nominalFunc, UnsafePointer<Int>.self))
    
    
    var types: [Any.Type] = []
    for i in 0..<numberOfField {
        let typeFetcher = funcBase.advancedBy(i).memory
        let type = unsafeBitCast(typeFetcher, Any.Type.self)
        types.append(type)
    }
    
    return types
}


private func getFieldNames(pointer: UnsafePointer<Int8>, fieldCount numberOfField: Int) -> [String]{
    
    return Array<String>(utf8Strings: pointer)
}



private func nominalTypeOfClass(typePointer t: UnsafePointer<Struct>) -> ObjectMetadata{
    
    let typePointer = unsafeBitCast(t, UnsafePointer<NominalTypeDescriptor.Class>.self)
    return nominalTypeOf(pointer: typePointer)
    
}

private func nominalTypeOf(pointer typePointer: UnsafePointer<NominalTypeDescriptor.Class>) -> ObjectMetadata{
    
    let intPointer = unsafeBitCast(typePointer, UnsafePointer<Int>.self)
    
    let typePointee = typePointer.memory
    let superPointee = typePointee.super_
    
    var superObject: ObjectMetadata
    
    if unsafeBitCast(typePointer.memory.isa, Int.self) == 14 || unsafeBitCast(superPointee, Int.self) == 0{
        superObject = ObjectMetadata(kind: .ObjCClassWrapper, propertyNames: [], propertyTypes: [], propertyOffsets: [])
        return superObject
    }else{
        superObject = nominalTypeOf(pointer: superPointee)
        superObject.kind = .`class`
    }
    
    
    let nominalTypeOffset = (sizeof(Int.self) == sizeof(Int64.self)) ? 8 : 11
    let nominalTypeInt = intPointer.advancedBy(nominalTypeOffset)
    
    let nominalTypeint8 = unsafeBitCast(nominalTypeInt, UnsafePointer<Int8>.self)
    let des = nominalTypeint8.advancedBy(typePointee.Description)
    
    let nominalType = unsafeBitCast(des, UnsafePointer<NominalTypeDescriptor>.self)
    
    let numberOfField = Int(nominalType.memory.numberOfFields)
    
    let int32NominalType = unsafeBitCast(nominalType, UnsafePointer<Int32>.self)
    let fieldBase = int32NominalType.advancedBy(3)
    
    let int8FieldBasePointer = unsafeBitCast(fieldBase, UnsafePointer<Int8>.self)
    let fieldNamePointer = int8FieldBasePointer.advancedBy(Int(nominalType.memory.fieldNames))
    
    let fieldNames = getFieldNames(fieldNamePointer, fieldCount: numberOfField)
    superObject.propertyNames.appendContentsOf(fieldNames)
    
    let int32NominalFunc = unsafeBitCast(nominalType, UnsafePointer<Int32>.self).advancedBy(4)
    let nominalFunc = unsafeBitCast(int32NominalFunc, UnsafePointer<Int8>.self).advancedBy(Int(nominalType.memory.getFieldTypes))
    
    let fieldType = getType(pointer: nominalFunc, fieldCount: numberOfField)
    superObject.propertyTypes.appendContentsOf(fieldType)
    
    let offsetPointer = intPointer.advancedBy(Int(nominalType.memory.FieldOffsetVectorOffset))
    var offsetArr: [Int] = []
    
    for i in 0..<numberOfField {
        let offset = offsetPointer.advancedBy(i)
        offsetArr.append(offset.memory)
    }
    superObject.propertyOffsets.appendContentsOf(offsetArr)
    
    return superObject
}
 
 
protocol UTF8Initializable {
    init?(UTF8String: UnsafePointer<CChar>)
}

extension String : UTF8Initializable {}

extension Array where Element : UTF8Initializable {
    
    init(utf8Strings: UnsafePointer<CChar>) {
        var strings = [Element]()
        var p = utf8Strings
        while let string = Element(UTF8String: p) {
            strings.append(string)
            while p.memory != 0 {
                p = p.advancedBy(1)
            }
            p = p.advancedBy(1)
            guard p.memory != 0 else { break }
        }
        self = strings
    }
}
