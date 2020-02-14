//
//  UIRouter.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD

class UIRouter {
    
    public var window    :UIWindow!
    public var currentVC :UIViewController?
    public var session   :Session

    public static var instance: UIRouter!
    
    init(session :Session) {
        
        self.session = session
        
        window = UIWindow(frame :UIScreen.main.bounds)

        UIRouter.instance = self
    }
    
    public func setNewRoot(vc: UIViewController?) {

        window.rootViewController = vc
        
        window.makeKeyAndVisible()
        
        currentVC = window.rootViewController
    }
    public var topVC: UIViewController? {
        
        if var topController = window.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }

        return nil
    }

    public func showStartUpScreen() {
        
        var vc :UIViewController?
        
//        if let _ = session.authorizationService.user {
//
//            vc = home.homeTabBar()
//
//        }else {
//
            vc = loginAndSignUp.loginVC()
//        }

        setNewRoot(vc: vc)
    }

    public lazy var loginAndSignUp: LoginAndSignUpUIRouter = {

        return LoginAndSignUpUIRouter(mainRouter: self, session: session)
    }()

    public lazy var home: HomeUIRouter = {

        return HomeUIRouter(mainRouter: self, session: session)
    }()
    
    //MARK:- Loading
    private var hud: MBProgressHUD?

    public func showLoading(in view: UIView? = nil) {

        let targetView = view ?? (currentVC?.view ?? window.rootViewController?.view)

        guard let targetView_ = targetView else {
            return
        }

        return hud = MBProgressHUD.showAdded(to: targetView_, animated: true)
    }

    public func dismissLoading() {
        
        hud?.hide(animated: true)
    }
    
    //MARK:-
    public func logOut(force: Bool = false) {

        let logOutAction = {[weak self] in

           // self?.session.logout()
            self?.showStartUpScreen()
        }

        if force {
            logOutAction()
        }else {

            let alert = UIAlertController(title: "SwiftTemplate", message: "Are you sure you want to sign out", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { _ in

                logOutAction()
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            topVC?.present(alert, animated: true, completion: nil)
        }
    }

    public func show(message: String, attributedMessage: NSAttributedString? = nil) {

        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)

        if let attrString = attributedMessage {

            alert.setValue(attrString, forKey: "attributedMessage")
        }

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        topVC?.present(alert, animated: true, completion: nil)
    }
}

public func stLog(log: String) {

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "

    print(formatter.string(from: Date()), terminator: "")
    print("ST_LOG: \(log)")
}
