//
//  AppDelegate.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var uiRouter: UIRouter!
    var session : Session!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        session = Session()

        uiRouter = UIRouter(session: session)

        uiRouter.showStartUpScreen()

        return true
    }
}

