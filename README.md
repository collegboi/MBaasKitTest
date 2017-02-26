# MBaasKitTest

## Description

Demonstrating how the pod MBaasKit works

## Requirements

* Swift 3
* Xcode 8.2.1

## Usage

```swift

struct TestObject: TBJSONSerializable {

    var name: String!

    init() {
    }

    init(name:String) {
        self.name = name
    }
    init( jsonObject : TBJSON) {
        self.name = jsonObject.tryConvert("name")
    }
}


var result = [TestObject]()
result.getAllInBackground(ofType:TestObject.self) { (succeeded: Bool, data: [TestObject]) -> () in

    DispatchQueue.main.async {
        if (succeeded) {
            result = data
            print("success")
        } else {
            print("error")
        }
    }
}

let testObject = TestObject(name: "timothy")

testObject.sendInBackground("objectID"){ (succeeded: Bool, data: NSData) -> () in

    DispatchQueue.main.async {
        if (succeeded) {
            print("scucess")
        } else {
            print("error")
        }
    }
}

```


## Author

Timothy Barnard

## License

MBaaSKit is available under the MIT license. See the LICENSE file for more info.
