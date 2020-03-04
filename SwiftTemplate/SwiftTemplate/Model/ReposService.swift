//
//  ReposService.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 3/4/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation
import RxSwift

final class ReposService {

    private let apiClient :APIClient!
    private var disposeBag  = DisposeBag()
    private weak var authService: AuthorizationService?
    
    init(apiClient: APIClient, authService: AuthorizationService) {

        self.apiClient   = apiClient
        self.authService = authService
    }
    
    public func getRepos(callBack: @escaping (([UserRepoResponse])->Void)) {

        guard let userLogin = authService?.userLogin else { return }

        return apiClient.request(API.GitHub.getReposFor(userName: userLogin))
                        .observeOn(MainScheduler.instance)
                        .subscribe(onSuccess: { result in

            callBack(result)

        }, onError: {error in

            //Show error message if needed
            callBack([])

        }).disposed(by: disposeBag)
    }
}
