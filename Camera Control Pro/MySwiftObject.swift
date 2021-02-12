//
//  MySwiftObject.swift
//  testCameraControlProApp
//
//  Created by Ed Connor on 1/31/21.
//

import Foundation

@objc(MySwiftObject)
class MySwiftObject : NSObject {

    @objc
    var someProperty: AnyObject = "Some Initializer Val" as NSString

    override init() {}

    @objc
    func someFunction(someArg: Any) -> NSString {
        return "You sent me \(someArg)" as NSString
    }
}
