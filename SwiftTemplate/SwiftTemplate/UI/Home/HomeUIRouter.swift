//
//  HomeUIRouter.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import UIKit

final class HomeUIRouter {
    
    private weak var mainRouter :UIRouter!
    private var session         :Session!
    private let storyboard      :UIStoryboard!
    
    init (mainRouter :UIRouter, session :Session) {
        
        self.mainRouter = mainRouter
        self.session    = session
        
        storyboard = UIStoryboard(name: "Home", bundle: nil)
    }

    public func homeTabBar() -> HomeTabBar {
        
        let tabBar = HomeTabBar.instantiateFrom(storyboard: storyboard)

        tabBar.viewControllers?.forEach({ vc in
            
            if let naVC = vc as? RepositoriesNavVC {

                guard let vc = naVC.viewControllers.first as? RepositoriesVC else {
                    //log error
                    return
                }

                UIRouter.instance.repos.setupRepositoriesReduxModuleFor(reposVC: vc)
            }
//
//            if let naVC = vc as? FoodNavVC {
//
//                let vc = naVC.viewControllers.first as! FoodVC
//
//                //menuVC.router  = mainRouter
//                vc.session = session
//            }
//
//            if let naVC = vc as? ChainsNavVC {
//
//                let vc = naVC.viewControllers.first as! ChainsVC
//
//                //menuVC.router  = mainRouter
//                vc.session = session
//            }
//
//            if let naVC = vc as? DocsNavVC {
//
//                let vc = naVC.viewControllers.first as! DocsVC
//
//                //menuVC.router  = mainRouter
//                vc.docsService = session.documentsService
//            }
//
//            if let naVC = vc as? SearchNavVC {
//
//                let vc = naVC.viewControllers.first as! SearchVC
//
//                UIRouter.instance.search.setup(searchVC: vc, tabBar: tabBar)
//            }
        })
        
        return tabBar
    }
}
