//
//  UserReposResponse.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 3/4/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation

struct UserRepoResponse: Codable, Equatable {
    let id: Int
    let name: String
    let url: String
    let contributors_url: String
    let created_at: String
    let language: String
    let open_issues_count: Int
    let watchers: Int
}
