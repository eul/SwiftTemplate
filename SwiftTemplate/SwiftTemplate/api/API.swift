//
//  API.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum API {}

extension API {
    
    enum GitHub {
        
        static func getUserInfoFor(userName: String) -> Endpoint<UserInfoResponse> {

           return Endpoint(method: .get,
                             path: "/users/\(userName)")
        }
    }
}
