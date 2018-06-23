//
//  CustomStringConvertible+AutoDescription.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 22/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

extension CustomStringConvertible {
    public var description : String {
        
        var description = "***** \(type(of: self)) *****\n"
        
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value)\n"
            }
        }
        
        description += "***** \(type(of: self)) *****\n"
        
        return description
    }
}
