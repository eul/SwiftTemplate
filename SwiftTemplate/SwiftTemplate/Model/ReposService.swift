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
    
    init(apiClient: APIClient) {

        self.apiClient = apiClient
    }
    
    public func getReposFor(userName: String, callBack: @escaping (([UserRepoResponse])->Void)) {

        return apiClient.request(API.GitHub.getReposFor(userName: userName))
                        .observeOn(MainScheduler.instance)
                        .subscribe(onSuccess: { result in

            callBack(result)

        }, onError: {error in

            //Show error message if needed
            callBack([])

        }).disposed(by: disposeBag)
    }
}
