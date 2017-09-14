
<p align="center" >
  <img src="https://github.com/IcyButterfly/MappingAce/blob/master/logo.png?raw=true" alt="MappingAce" title="MappingAce">
</p>


[![Swift](https://img.shields.io/badge/Swift-3.0+-orange.svg?style=flat)](https://swift.org)
[![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://swift.org)

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MappingAce.svg)](https://img.shields.io/cocoapods/v/MappingAce.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license)

*Swift JSON to Struct, class*

MappingAce allows rapid creation of struct , Swift class, OC class . Automatic transform dictionary to model(model could be struct), forget to manually write property mapping code


- [Usage](#usage)
	- [JSON -> Model](#json-model) 
		- [Raw struct ](#raw-struct)
		- [Nested struct mapping](#nested-struct-mapping)
		- [Optional property](#optional-property)
		- [Enum](#enum)
		- [Struct or class has default property value](#struct-or-class-has-default-property-value)
	- [Model -> JSON](#model-json)
		- just implement protocol `Serializable`
- [Installation](#installation)



## Usage

### JSON -> Model

##### Raw struct 

```

// It is recommend to implement protocol `Mapping`, and just implement `Mapping`, no more works
struct PhoneNumber: Mapping{
    var tel: String
    var type: String
}

let phoneInfo: [String : Any] = [
    "tel": "186xxxxxxxx",
    "type": "work"
]
let phone = PhoneNumber(fromDic: phoneInfo)

print(phone.tel) //"186xxxxxxxx"
print(phone.type) //"work"



// Struct did not implement the `Mapping` protocol
struct PhoneNumber {
    var tel: String
    var type: String
}

let phone = MappingAny(type: PhoneEntity.self, fromDic: phoneInfo)
    
```
##### Nested struct mapping

```
struct User{
    var age: Int
    var name: String
    var phone: PhoneNumber
}

// if you want your serilized nested struct, just implement the `Mapping` protocol
struct PhoneNumber: Mapping {
    var tel: String
    var type: String
}

let dic: [String : Any] = [
    "age" : 24,
    "name": "Binglin",
    "phone": phoneInfo
]

let user = MappingAny(type: User.self, fromDic: dic)
```

###### Optional property
```
struct User{
    var age: Int?
    var name: String?
    var phone: PhoneNumber?
}

private struct PhoneNumber: Mapping {
    var tel: String
    var type: String
}

let dic: [String : Any] = [
    "name": "Binglin",
]

let user = MappingAny(type: User.self, fromDic: dic)

XCTAssertEqual(user.age, nil)
XCTAssertEqual(user.name, "Binglin")
XCTAssertEqual(user.phone?.tel, nil)
XCTAssertEqual(user.phone?.type, nil)
```

##### Enum
enum  type of Int & String  is support
```
// eg: EnumInt
enum Gender: Int, EnumInt{
    case male = 1
    case female = 2
}

struct User: Mapping{
    var gender: Gender
}

let dicGender: [String : Any] = ["gender": 1]
let userMale = User(fromDic: dicGender)

XCTAssertEqual(userMale.gender, Gender.male)
```

```
// when enum is string type
enum Gender: String, EnumString{
    case male = "m"
    case female = "f"
}
```


### Struct or class has default property value   
protocol:  InitMapping (Struct or Class)

```
// struct
struct User: InitMapping{
    var name: String = "default"
    var age: Int?
}

let dic: [String : Any] = ["age": 14]
let user = User(fromDic: dic)

print(user.name) //"default"
print(user.age)  //14


// class
// need to implement an empty initializer.
class User: NSObject, InitMapping{
    var name: String = "default"
    var age: Int?

    required override init() {}/*required*/
}

let dic: [String : Any] = ["name" : "IB"]
let user = User(fromDic: dic)
```




### Model -> JSON


```
// for object implement Mapping or InitMapping
struct PhoneNumber: Mapping {
    var tel: String
    var type: String
}

let phone = PhoneNumber(tel: "186xxxxxxxx", type: "work")
let toDic = phone.toDictionary()
print(toDic) // ["type": "work", "tel": "186xxxxxxxx"]


// for object do not implement Mapping or InitMapping
// just implement protocol Serializable
struct PhoneNumber: `Serializable` {
    var tel: String
    var type: String
}

let phone = PhoneNumber(tel: "186xxxxxxxx", type: "work")
let toDic = phone.toDictionary()
print(toDic) // ["type": "work", "tel": "186xxxxxxxx"]
```




## Installation

| swift version | framework version |
| - | - |
| 3.0 | 1.0.2 |
| 3.1 | 1.0.3 |
| 4.0 | 1.0.4 |


### Installation with CocoaPods

#### Podfile

To integrate MappingAce into your Xcode project using CocoaPods, specify it in your `Podfile`:


```ruby
platform :ios, '8.0'

target 'TargetName' do
pod 'MappingAce', '~> 1.0.3'
end
```


Then, run the following command:

```bash
$ pod install
```

### Installation with [Carthage](https://github.com/Carthage/Carthage)
To integrate MappingAce into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "IcyButterfly/MappingAce" ~> 1.0.3
```

Run `carthage` to build the framework and drag the built `MappingAce.framework` into your Xcode project.
