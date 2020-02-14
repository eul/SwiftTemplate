//
//  LoginVC.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import UIKit

final class LoginVC: UIViewController, StateViewer, Storyboarded {

    var eventHandler: AnyEventHandler<LoginState.Event>?

    typealias State = LoginState
    typealias Event = LoginState.Event
    
    //MARK:-
    public func render(state: LoginState) {
        
        switch state {
        case .loading:
            UIRouter.instance.showLoading(in: view)
        default:
            UIRouter.instance.dismissLoading()
        }
    }

    //MARK:- Actions
    @IBAction func loginAction(_ sender: Any) {

        eventHandler?.handle(event: .login("", ""))
    }
}
