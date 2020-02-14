//
//  STError.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation

class STError: Error {
    
    public var code = 0
    public var errorDescription: String?
    
    init() {
        
    }
    
    init(code: Int) {
        self.code = code
    }
    
    init(description: String) {
        errorDescription = description
    }
    
    public func description() -> String {
        return errorDescription ?? "ST network Error"
    }
}

class NoInternetError: STError {}

class NewVersionAvailableError: STError {}

class ReloginRequiredError: STError {}

class LoginError: STError {}
