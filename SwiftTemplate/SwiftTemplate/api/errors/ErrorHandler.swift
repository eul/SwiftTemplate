//
//  ErrorHandler.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation
import Alamofire

final class ErrorHandler {
    
    public func wrap(error: Error, response: DataResponse<Data>) -> STError {

        stLog(log: "Error in: \(response.request as Any)")

        var snapError = STError()

        let afError = (error as? AFError)

        if let afError_ = afError {

            switch afError_.responseCode {
            case 401:
                return ReloginRequiredError()
            default:
                stLog(log: "Unhandled AFError: \(afError_.responseCode ?? 0)")
            }
        }
        
        if ((error as NSError).code == -1009) || ((error as NSError).code == -1001) {

            snapError = NoInternetError()
        }

        stLog(log:"Unhandled Error: \((error as NSError).code)")
        
        if let data = response.data {

            do {

                let dict = String(data: data, encoding: String.Encoding.utf8) as String?

                print(dict as Any)

                if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                    if (afError?.responseCode ?? 0) == 400 {
                        
                        guard let _ = dict["error"] as? String,
                              let description = dict["error_description"] as? String else {

                                return snapError
                        }

                        return LoginError(description: description)
                    }
                }
            }catch {

            }
        }

        return snapError
    }
    
    public func handle(error: Error, description: String? = nil) {
        
        DispatchQueue.main.async {
            
            if error is NoInternetError {

               UIRouter.instance.show(message: "It seems there is no internet connection. Please check and try again.")

            } else if error is ReloginRequiredError {

                UIRouter.instance.logOut(force: true)
            }
            else if error is LoginError {

                UIRouter.instance.show(message: "Hmm, the email or password didn’t work. Please try again")

            } else if let error_ = error as? STError {

                stLog(log: "TOMATO API Error: \(error_.code)")

                UIRouter.instance.show(message: "Something went wrong. Please try again later.")
            }
        }
    }
}
