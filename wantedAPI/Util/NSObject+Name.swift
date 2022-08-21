//
//  NSObject+Name.swift
//  wantedAPI
//
//  Created by OsakaMiseri on 2022/08/20.
//

import UIKit

extension NSObject {
    public class var className: String {
        String(describing: self)
    }

    public var className: String {
        String(describing: type(of: self))
    }
}
