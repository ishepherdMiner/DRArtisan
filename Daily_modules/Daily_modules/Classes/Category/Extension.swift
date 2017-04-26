//
//  Extension.swift
//  Daily_modules
//
//  Created by Jason on 26/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

import Foundation

extension NSObject {
    // create a static method to get a swift class for a string name
    public class func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
            let classStringName = "_TtC\(appName.lengthOfBytes(using: String.Encoding.utf8))\(appName)\(className.lengthOfBytes(using: String.Encoding.utf8))\(className)"
            // return the class!
            return NSClassFromString(classStringName)
        }
        return nil;
    }
    
    public class func getPropertiesInfo(cls:AnyClass?, recursive:Bool) -> Any! {
        
        var clsM = cls
        var glist = [String]()
        var outCount:UInt32 = 0;
        
        repeat {
            let properties:UnsafeMutablePointer<objc_property_t?> = class_copyPropertyList(clsM, &outCount);
            for index in 0..<outCount {
                let property = property_getName(properties[Int(index)])
                let result = String(cString: property!)
                glist.append(result)
            }
            clsM = clsM?.superclass()
            print(clsM! == NSObject.self);
        }while (clsM! != NSObject.self && recursive)
        
        return glist
    }
}
