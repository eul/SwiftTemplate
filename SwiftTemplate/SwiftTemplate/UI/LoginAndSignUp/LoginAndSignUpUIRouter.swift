//
//  LoginAndSignUpUIRouter.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import UIKit

class LoginAndSignUpUIRouter {
    
    private weak var mainRouter :UIRouter!
    private var session         :Session!
    private let storyboard      :UIStoryboard!
    
    init (mainRouter :UIRouter, session :Session) {
        
        self.mainRouter = mainRouter
        self.session    = session
        
        storyboard = UIStoryboard(name: "LoginAndSignUp", bundle: nil)
    }
    
    public func loginVC() -> UIViewController? {

        guard let navc = storyboard.instantiateViewController(withIdentifier: String("LoginNavc")) as? UINavigationController,
                let vc = navc.viewControllers.first as? LoginVC else {
            return nil
        }

        setupLoginReduxModuleFor(loginVC: vc)

        mainRouter.currentVC = navc

        return navc
    }

    //MARK:- Private methods
    private func setupLoginReduxModuleFor(loginVC: LoginVC) {
        
        let routingHandler: ((LoginReducer.RoutingEvent)->Void) = { event in

            switch event {

            case .didLogin(let userInfo):

                UIRouter.instance.setNewRoot(vc: UIRouter.instance.home.homeTabBar())
            }
        }

        let reducer = LoginReducer(authorizationService: session.authorizationService,
                                         routingHandler: routingHandler)

        _ = StateManager(state: .initial,
                       reducer: reducer,
                   stateViewer: loginVC)
    }
}
