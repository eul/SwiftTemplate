//
//  RepositoriesState.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 3/4/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation

import RxSwift

enum RepositoriesState: ViewState, Equatable {

    case initial
    case loading
    case loadingError
    case repositories([UserRepoResponse])

    enum Event {
        case login(_ userName: String, _ password: String)
    }

    static func == (lhs: RepositoriesState, rhs: RepositoriesState) -> Bool {
        
        switch (lhs, rhs) {
        case (.initial, .initial),
             (.loading, .loading),
             (.loadingError, .loadingError):
            return true
        case (.repositories(let lRepos), .repositories(let rRepos)):
            return lRepos == rRepos
        default:
            return false
        }
    }
}
