//
//  LoginState.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation
import RxSwift

enum LoginState: ViewState, Equatable {
    
    case initial
    case loading
    case logined
    case loginError

    enum Event {
        case login(_ userName: String, _ password: String)
    }

    static func == (lhs: LoginState, rhs: LoginState) -> Bool {
        
        switch (lhs, rhs) {
        case (.initial, .initial),
             (.loading, .loading),
             (.logined, .logined),
             (.loginError, .loginError):
            return true
        default:
            return false
        }
    }
}

class LoginReducer: Reducer {

    typealias State = LoginState
    typealias Event = LoginState.Event

    public var newStateHandler: ((LoginState) -> Void)?

    private let authorizationService: AuthorizationService
    private let routingHandler      : ((RoutingEvent)->Void)?
    private var disposeBag = DisposeBag()
    
    enum RoutingEvent{
        case didLogin(UserInfoResponse)
    }

    init(authorizationService: AuthorizationService,
               routingHandler: ((RoutingEvent)->Void)?) {

        self.authorizationService = authorizationService
        self.routingHandler       = routingHandler
    }

    func reduce(state: LoginState, event: LoginState.Event) -> LoginState {

        var newState = state

        switch (state, event) {
        case (_, .login(let userName, let password)):

            newState = .loading

            login(userName: userName, password: password)

        default:

            fatalError()
        }

        return newState
    }

    private func login(userName: String, password: String) {

        
        authorizationService.getUserInfoWith(userLogin: userName) {[weak self] userInfo in

            if let userInfo_ = userInfo {
                self?.routingHandler?(.didLogin(userInfo_))
            }else {
                self?.newStateHandler?(.loginError)
            }
        }
    }
}
