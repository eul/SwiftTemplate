//
//  AuthorizationService.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation
import RxSwift

final class AuthorizationService {

    private let apiClient :APIClient!
    private let fileStorage = FileStorage()
    private var disposeBag  = DisposeBag()

//    public var user :UserData? {
//        didSet{
//            if let user_ = user {
//
//                fileStorage.save(user: user_)
//            }else {
//
//                fileStorage.removeUser()
//            }
//        }
//    }
    
    init(apiClient: APIClient) {

        self.apiClient = apiClient

        //user = fileStorage.getUser()
        //self.apiClient.identityToken = user?.authToken
    }
}

