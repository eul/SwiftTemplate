//
//  RepositoriesUIRouter.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 3/4/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import UIKit

class RepositoriesUIRouter {
    
    private weak var mainRouter :UIRouter!
    private var session         :Session!
    private let storyboard      :UIStoryboard!
    
    init (mainRouter :UIRouter, session :Session) {
        
        self.mainRouter = mainRouter
        self.session    = session
        
        storyboard = UIStoryboard(name: "Repositories", bundle: nil)
    }
    
    public func setupRepositoriesReduxModuleFor(reposVC: RepositoriesVC) {

        let routingHandler: ((RepositoriesReducer.RoutingEvent)->Void) = { event in

        }

        let reducer = RepositoriesReducer(reposService: session.reposService, routingHandler: routingHandler)

        _ = StateManager(state: .initial,
                       reducer: reducer,
                   stateViewer: reposVC)
    }
}
