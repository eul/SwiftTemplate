//
//  UserInfoResponse.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation

struct UserInfoResponse: Codable {
    let id: Int
    let avatar_url: String?
    let repos_url: String?
}
