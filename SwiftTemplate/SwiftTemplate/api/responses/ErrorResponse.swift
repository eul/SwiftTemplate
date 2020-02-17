//
//  ErrorResponse.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/17/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let message: String
    let documentation_url: String
}
