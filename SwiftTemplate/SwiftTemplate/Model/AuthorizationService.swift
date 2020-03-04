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

    public var userLogin: String?
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
    
    public func getUserInfoWith(userLogin: String, callBack: @escaping ((UserInfoResponse?)->Void)) {

        return apiClient.request(API.GitHub.getUserInfoFor(userName: userLogin))
                        .observeOn(MainScheduler.instance)
                        .subscribe(onSuccess: {[weak self] result in

            self?.userLogin = userLogin

            callBack(result)

        }, onError: {error in

            //Show error message if needed
            callBack(nil)

        }).disposed(by: disposeBag)
    }
}

