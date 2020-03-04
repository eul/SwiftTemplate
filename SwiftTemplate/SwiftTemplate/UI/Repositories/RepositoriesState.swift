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
        case loadData
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

class RepositoriesReducer: Reducer {

    typealias State = RepositoriesState
    typealias Event = RepositoriesState.Event

    public var newStateHandler: ((RepositoriesState) -> Void)?

    private let reposService: ReposService
    private let routingHandler: ((RoutingEvent)->Void)?
    private var disposeBag = DisposeBag()
    
    enum RoutingEvent{
        case showDetails
    }

    init(reposService: ReposService,
       routingHandler: ((RoutingEvent)->Void)?) {

        self.reposService = reposService
        self.routingHandler = routingHandler
    }

    func reduce(state: RepositoriesState, event: RepositoriesState.Event) -> RepositoriesState {

        var newState = state

        switch (state, event) {
        case (_, .loadData):

            newState = .loading

            loadData()

        default:

            fatalError()
        }

        return newState
    }

    private func loadData() {

        reposService.getRepos() {[weak self] repos in

            print(repos)

            self?.newStateHandler?(.repositories(repos))
        }
    }
}
