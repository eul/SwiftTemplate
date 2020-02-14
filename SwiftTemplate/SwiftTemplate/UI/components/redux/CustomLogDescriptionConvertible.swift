//
//  CustomLogDescriptionConvertible.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

public protocol CustomLogDescriptionConvertible {
    var logDescription: String { get }
}

public extension CustomLogDescriptionConvertible {
    var logDescription: String {
        return String(describing: self)
    }
}
