//
//  Session.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation
final class Session {

    public let authorizationService: AuthorizationService

    private var apiClient: APIClient!

    init() {

        apiClient = APIClient(accessToken: nil)

        authorizationService = AuthorizationService(apiClient: apiClient)
    }
//
//    public func logout() {
//        
//        authorizationService.user = nil
//    }
}
