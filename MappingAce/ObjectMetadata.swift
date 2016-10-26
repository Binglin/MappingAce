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
    public var kind: MetadataKind
    public var propertyNames: [String]
    public var propertyTypes: [Any.Type]
    public var propertyOffsets: [Int]
}


func MetadataInfoFor(type: Any.Type) -> ObjectMetadata{
    
    let typePointer = unsafeBitCast(type, to: UnsafePointer<Struct>.self)
    //print(type, "pointer is", typePointer)
    let typeStruct = typePointer.pointee
    let kind = typeStruct.kind
    
    struct TypeInfoHashTable{
        static var table: [UnsafePointer<Struct> : ObjectMetadata] = [:]
    }
    
    if let structInfo = TypeInfoHashTable.table[typePointer]{
        return structInfo
    }

    if kind == 1{
        let info = nominalTypeOfStruct(typePointer: typePointer)
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
    
    let intPointer = unsafeBitCast(typePointer, to: UnsafePointer<Int>.self)
    
    let nominalTypeBase = intPointer.advanced(by: 1)
    let int8Type = unsafeBitCast(nominalTypeBase, to: UnsafePointer<Int8>.self)
    let nominalTypePointer = int8Type.advanced(by: typePointer.pointee.nominalTypeDescriptorOffset)
    
    
    let nominalType = unsafeBitCast(nominalTypePointer, to: UnsafePointer<NominalTypeDescriptor>.self)
    let numberOfField = Int(nominalType.pointee.numberOfFields)
    
    
    let int32NominalType = unsafeBitCast(nominalType, to: UnsafePointer<Int32>.self)
    let fieldBase = int32NominalType.advanced(by: Int(nominalType.pointee.FieldOffsetVectorOffset))
    
    let int8FieldBasePointer = unsafeBitCast(fieldBase, to: UnsafePointer<Int8>.self)
    let fieldNamePointer = int8FieldBasePointer.advanced(by: Int(nominalType.pointee.fieldNames))
    
    let fieldNames = getFieldNames(pointer: fieldNamePointer, fieldCount: numberOfField)
    
    let int32NominalFunc = unsafeBitCast(nominalType, to: UnsafePointer<Int32>.self).advanced(by: 4)
    let nominalFunc = unsafeBitCast(int32NominalFunc, to: UnsafePointer<Int8>.self).advanced(by: Int(nominalType.pointee.getFieldTypes))
    
    let fieldType = getType(pointer: nominalFunc, fieldCount: numberOfField)
    
    let offsetPointer = intPointer.advanced(by: Int(nominalType.pointee.FieldOffsetVectorOffset))
    var offsetArr: [Int] = []
    
    for i in 0..<numberOfField {
        let offset = offsetPointer.advanced(by: i)
        offsetArr.append(offset.pointee)
    }
    
    let info = ObjectMetadata(kind: .struct,propertyNames: fieldNames, propertyTypes: fieldType, propertyOffsets: offsetArr)
    return info
}

 

private func getType(pointer nominalFunc: UnsafePointer<Int8>, fieldCount numberOfField: Int) -> [Any.Type]{
        
    let funcPointer = unsafeBitCast(nominalFunc, to: FieldsTypeAccessor.self)
    let funcBase = funcPointer(unsafeBitCast(nominalFunc, to: UnsafePointer<Int>.self))
    
    
    var types: [Any.Type] = []
    for i in 0..<numberOfField {
        let typeFetcher = funcBase.advanced(by: i).pointee
        let type = unsafeBitCast(typeFetcher, to: Any.Type.self)
        types.append(type)
    }
    
    return types
}


private func getFieldNames(pointer: UnsafePointer<Int8>, fieldCount numberOfField: Int) -> [String]{
    
    return Array<String>(utf8Strings: pointer)
}



private func nominalTypeOfClass(typePointer t: UnsafePointer<Struct>) -> ObjectMetadata{
    
    let typePointer = unsafeBitCast(t, to: UnsafePointer<NominalTypeDescriptor.Class>.self)
    return nominalTypeOf(pointer: typePointer)
    
}

private func nominalTypeOf(pointer typePointer: UnsafePointer<NominalTypeDescriptor.Class>) -> ObjectMetadata{
    
    let intPointer = unsafeBitCast(typePointer, to: UnsafePointer<Int>.self)
    
    let typePointee = typePointer.pointee
    let superPointee = typePointee.super_
    
    var superObject: ObjectMetadata
    
    if unsafeBitCast(typePointer.pointee.isa, to: Int.self) == 14 || unsafeBitCast(superPointee, to: Int.self) == 0{
        superObject = ObjectMetadata(kind: .ObjCClassWrapper, propertyNames: [], propertyTypes: [], propertyOffsets: [])
        return superObject
    }else{
        superObject = nominalTypeOf(pointer: superPointee)
        superObject.kind = .class
    }
    
    let nominalTypeOffset = (MemoryLayout<Int>.size == MemoryLayout<Int64>.size) ? 8 : 11
    let nominalTypeInt = intPointer.advanced(by: nominalTypeOffset)
    
    let nominalTypeint8 = unsafeBitCast(nominalTypeInt, to: UnsafePointer<Int8>.self)
    let des = nominalTypeint8.advanced(by: typePointee.Description)
    
    let nominalType = unsafeBitCast(des, to: UnsafePointer<NominalTypeDescriptor>.self)
    
    let numberOfField = Int(nominalType.pointee.numberOfFields)
    
    let int32NominalType = unsafeBitCast(nominalType, to: UnsafePointer<Int32>.self)
    let fieldBase = int32NominalType.advanced(by: 3)//.advanced(by: Int(nominalType.pointee.FieldOffsetVectorOffset))
    
    let int8FieldBasePointer = unsafeBitCast(fieldBase, to: UnsafePointer<Int8>.self)
    let fieldNamePointer = int8FieldBasePointer.advanced(by: Int(nominalType.pointee.fieldNames))
    
    let fieldNames = getFieldNames(pointer: fieldNamePointer, fieldCount: numberOfField)
    superObject.propertyNames.append(contentsOf: fieldNames)
    
    let int32NominalFunc = unsafeBitCast(nominalType, to: UnsafePointer<Int32>.self).advanced(by: 4)
    let nominalFunc = unsafeBitCast(int32NominalFunc, to: UnsafePointer<Int8>.self).advanced(by: Int(nominalType.pointee.getFieldTypes))
    
    let fieldType = getType(pointer: nominalFunc, fieldCount: numberOfField)
    superObject.propertyTypes.append(contentsOf: fieldType)
    
    let offsetPointer = intPointer.advanced(by: Int(nominalType.pointee.FieldOffsetVectorOffset))
    var offsetArr: [Int] = []
    
    for i in 0..<numberOfField {
        let offset = offsetPointer.advanced(by: i)
        offsetArr.append(offset.pointee)
    }
    superObject.propertyOffsets.append(contentsOf: offsetArr)
    
    return superObject
}
 
 
protocol UTF8Initializable {
    init?(validatingUTF8: UnsafePointer<CChar>)
}

extension String : UTF8Initializable {}

extension Array where Element : UTF8Initializable {
    
    init(utf8Strings: UnsafePointer<CChar>) {
        var strings = [Element]()
        var p = utf8Strings
        while let string = Element(validatingUTF8: p) {
            strings.append(string)
            while p.pointee != 0 {
                p = p.advanced(by: 1)
            }
            p = p.advanced(by: 1)
            guard p.pointee != 0 else { break }
        }
        self = strings
    }
}
