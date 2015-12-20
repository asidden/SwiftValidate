# swift-validate
##### enhanced validation for swift

By [Danilo Topalovic](http://blog.danilo-topalovic.de).



* [Introduction]
* [Requirements]
* [Usage]
* [Included Validators]
  + [Empty]
  + [StrLen]
  + [Alnum]
  + [Email]
  + [Regex]
  + [Numeric]
  + [Between]
  + [GreaterThan]
  + [SmallerThan]
  + [DateTime]
  + [DateBetween]
  + [Callback]
  + [InArray]
* [Extensibility]


### Introduction

Unfortunately I did not find a fancy name for this software so I've called it what it is - a validator.

Heavily inspired by [Zend\Validate] and [Eureka] I started working on this component and delivered the alpha 1 day later ;-).

Support for Cocoapods will be added asap

### Requirements

* iOS 8.0+
* XCode 7.0+

### Usage

```swift
let validatorChain = ValidatorChain() {
    $0.stopOnFirstError = true
    $0.stopOnException = true
} <<< ValidatorEmpty() {
    $0.allowNil = false
} <<< ValidatorStrLen() {
    $0.minLength = 3
    $0.maxLength = 30
    $0.errorMessageTooSmall = "My fancy own error message"
}

let myValue = "testValue"

let result = validatorChain.validate(myValue, context: nil)
let errors = validatorChain.errors
```

### Included Validators

---

#### ValidatorEmpty()

Tests if the given value is not an empty string

**Configuration**

| value          |  type  | default | description                     |
|----------------|:------:|---------|---------------------------------|
| `allowNil`     |  Bool  | true    | value can be nil                |

**Error Messages**

* `errorMessage` - error message if value is empty

#### ValidatorStrLen()

Tests if a given value is between min and max in strlen

**Configuration**

| value       | type | default | description              |
|-------------|:----:|---------|--------------------------|
| `allowNil`  | Bool | true    | value an be nil          |
| `minLength` |  Int | 3       | minimum length of string |
| `maxLength` |  Int | 30      | maximum length of string |

**Error Messages**
+ `errorMessageNotAString: String` - error message if not a string
+ `errorMessageTooSmall: String` - error message if string is not long enaugh
+ `errorMessageTooLarge: String`- error message if string is too long

#### ValidatorAlnum()

Validates that the given value contains only alphanumerical chars

**configuration**

| value        | type | default | description        |
|--------------|:----:|---------|--------------------|
| `allowNil`   | Bool | true    | value an be nil    |
| `allowEmpty` | Bool | false   | value can be empty |

**Error Messages**

+ `errorMessageStringNotAlnum: String` - (optional)

#### ValidatorEmail()

Validates a given email address

**Configuration**

| value                  | type | default | description                                             |
|------------------------|:----:|---------|---------------------------------------------------------|
| `allowNil`             | Bool | true    | value an be nil                                         |
| `validateLocalPart`    | Bool | true    | the local part of the mail address will be validated    |
| `validateHostnamePart` | Bool | true    | the hostname part of the mail address will be validated |
| `strict`               | Bool | true    | the length of the parts will also be validated          |
|                        |      |         |                                                         |

**Error Messages**

+ `errorMessageInvalidAddress` - address is invalid
+ `errorMessageInvalidLocalPart` - the local part (before @) is invalid
+ `errorMessageInvalidHostnamePart` - the hostname is invalid
+ `errorMessagePartLengthExceeded` - a part is exceeding its length

#### ValidatorRegex()

Validates a given string against a user definded regex

| value             |            type            | default | description                        |
|-------------------|:--------------------------:|---------|------------------------------------|
| `allowNil`        |            Bool            | true    | nil is allowed                     |
| `pattern`         |           String           | -       | the pattern to match against       |
| `options`         | NSRegularExpressionOptions | 0       | options for the regular expression |
| `matchingOptions` |      NSMatchingOptions     | 0       | options for the matching           |

**Error Messages**

+ `errorMessageValueIsNotMatching` - value does not match teh given pattern

#### ValidatorNumeric()

Validates if the given value is a valid number

**Configuration**

| value                |        type       | default | description                        |
|----------------------|:-----------------:|---------|------------------------------------|
| `allowNil`           |        Bool       | true    | nil is allowed                     |
| `canBeString`        |        Bool       | true    | value can be a numerical string    |
| `allowFloatingPoint` |        Bool       | true    | value can be a floatingpoint value |

**Error Messages**

+ `errorMessageNotNumeric` - value is not numeric

#### ValidatorBetween()

Validates if a numerical value is between 2 predefined values

Generic:
```swift
let validator = ValidatorBetween<Double>() {
    $0.minValue = 1.0
    $0.maxValue = 99.1
}
```
**Configuration**

| value          | type | default | description                               |
|----------------|:----:|---------|-------------------------------------------|
| `allowNil`     | Bool | true    | nil is allowed                            |
| `allowString`  | Bool | true    | value can be a numerical string           |
| `minValue`     | TYPE | 0       | the minimum value                         |
| `maxValue`     | TYPE | 0       | the maximum value                         |
| `minInclusive` | Bool | true    | minimum value inclusive (>= instead of >) |
| `maxInclusive` | Bool | true    | maximum value inclusive                   |

**Error Messages**

+ `errorMessageInvalidType` - invalid type given [-should be thrown-]
+ `errorMessageNotBetween` - value is not between the predefined values

#### ValidatorGreaterThan()

Validates if the given value is greater than the predefined one

Generic:
```swift
let validator = ValidatorGreaterThan<Double>() {
    $0.min = 1.0
}
```

**Configuration**

| value          | type | default | description                               |
|----------------|:----:|---------|-------------------------------------------|
| `allowNil`     | Bool | true    | nil is allowed                            |
| `min`          | TYPE | 0       | the value that needs to be exceeded       |
| `inclusive`    | Bool | true    | value itself inclusive                    |

**Error Messages**

+ `errorMessageInvalidType` - invalid type given [-should be thrown-]
+ `errorMessageNotGreaterThan` - value is not great enaugh

#### ValidatorSmallerThan()

Validates if the given value is smaller than the predefined one

Generic:
```swift
let validator = ValidatorSmallerThan<Double>() {
    $0.max = 10.0
}
```

**Configuration**

| value          | type | default | description                               |
|----------------|:----:|---------|-------------------------------------------|
| `allowNil`     | Bool | true    | nil is allowed                            |
| `max`          | TYPE | 0       | the value that needs to be exceeded       |
| `inclusive`    | Bool | true    | value itself inclusive                    |

**Error Messages**

+ `errorMessageInvalidType` - invalid type given [-should be thrown-]
+ `errorMessageNotSmallerThan` - value is not small enaugh

#### ValidatorDateTime()

Validates if the given date is a valid one

**Configuration**

| value          | type   | default | description                               |
|----------------|:------:|---------|-------------------------------------------|
| `allowNil`     | Bool   | true    | nil is allowed                            |
| `dateFormat`   | String | 0       | the date format to be parsed              |

**Error Messages**

+ `errorMessageInvalidDate` - invalid date given

#### ValidatorDateBetween()

Validates if the given date (NSDate or String) is between the predefined dates

**Configuration**

| value           |       type      | default | description                                                 |
|-----------------|:---------------:|---------|-------------------------------------------------------------|
| `allowNil`      |       Bool      | true    | nil is allowed                                              |
| `min`           |      NSDate     | !       | minimum date                                                |
| `max`           |      NSDate     | !       | maximum date                                                |
| `minInclusive`  | Bool            | true    | minimum value inclusive (>= instead of >)                   |
| `maxInclusive`  | Bool            | true    | maximum value inclusive                                     |
| `dateFormatter` | NSDateFormatter | !       | date formatter for parsing the string if string is expected |

**Error Messages**

+ `errorMessageNotBetween` - Date is not between the predefined ones

#### ValidatorCallback()

Executes the given callback and works with the results

**Configuration**

| value          | type     | default | description                               |
|----------------|:--------:|---------|-------------------------------------------|
| `allowNil`     | Bool     | true    | nil is allowed                            |
| `callback`     | closure  | !       | the callback to validate with             |

Callback be like:
```swift
let validator = ValidatorCallback() {
    $0.callback = {(validator: ValidatorCallback, value: Any?, context: [String : Any?]?) in
        
        if nil == value {
            /// you can throw
            throw NSError(domain: "my domain", code: 1, userInfo: [NSLocalizedDescriptionKey: "nil!!"])
        }
        
        return (false, "My Error Message")
        /// return (true, nil)
    }
}
```

#### ValidatorInArray()

Validates that the given value is contained in the predefined array

Generic:
```swift
let validator = ValidatorInArray<String>() {
    $0.array = ["Andrew", "Bob", "Cole", "Dan", "Edwin"]
}

let validator = ValidatorInArray<Double>() {
    $0.allowNil = false
    $0.array = [2.4, 3.1, 9.8, 4.9, 2.0]
}
```

**Configuration**

| value          | type     | default | description                               |
|----------------|:--------:|---------|-------------------------------------------|
| `allowNil`     | Bool     | true    | nil is allowed                            |
| `array`        | [TYPE]   | []      | the array with predefined values          |

**Error Messages**

+ `errorMessageItemIsNotContained` - given value is not contained in the array

# Extensibility

Non generic:
```swift
class MyValidator: BaseValidator, ValidatorProtocol {

    required public init(@noescape _ initializer: MyValidator -> () = { _ in }) {
        super.init()
        initializer(self)
    }
    
    override func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        /// ...
    }
}
```

Generic:

```swift
class MyGenericValidator<TYPE where TYPE: Equatable>: ValidatorProtocol {

    required public init(@noescape _ initializer: MyGenericValidator -> () = { _ in }) {
        initializer(self)
    }

    public func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
        /// ...
    }
}
```

<!--- References -->

[Eureka]: https://github.com/xmartlabs/Eureka
[Zend\Validate]: https://github.com/zendframework/zend-validator

[Introduction]: #introduction
[Requirements]: #requirements
[Usage]: #usage
[Included Validators]: #included-validators
[Empty]: #validatorempty
[StrLen]: #validatorstrlen
[Alnum]: #validatoralnum
[Email]: #validatoremail
[Regex]: #validatorregex
[Numeric]: #validatornumeric
[Between]: #validatorbetween
[GreaterThan]: #validatorgreaterthan
[SmallerThan]: #validatorsmallerthan
[DateTime]: #validatordatetime
[DateBetween]: #validatordatebetween
[Callback]: #validatorcallback
[InArray]: #validatorinarray
[Extensibility]: #extensibility