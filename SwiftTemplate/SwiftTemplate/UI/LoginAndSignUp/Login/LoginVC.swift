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

    //AMRK:- Outlets
    @IBOutlet weak var userNameTF: UITextField!

    //MARK:-
    public func render(state: LoginState) {
        
        switch state {
        case .loading:
            UIRouter.instance.showLoading(in: view)
        case .loginError:
            UIRouter.instance.dismissLoading()
            print("login error")
        default:
            UIRouter.instance.dismissLoading()
        }
    }

    //MARK:- Actions
    @IBAction func loginAction(_ sender: Any) {

        if !validate() {
            return
        }

        eventHandler?.handle(event: .login(userNameTF.text ?? "", ""))
    }

    //MARK:- Validation
    private func validate() -> Bool {
        
        if userNameTF.text?.isEmpty ?? true {

            UIRouter.instance.show(message: "User name should be filled!")

            return false
        }

        return true
    }
}
