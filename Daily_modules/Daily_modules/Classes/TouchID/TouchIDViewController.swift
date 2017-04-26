//
//  TouchIDViewController.swift
//  Daily_modules
//
//  Created by Jason on 25/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        authenticateUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func authenticateUser() {
        // Get the local authentication context.
        let context = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        let reasonString = "按下你的🐾"
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            _ = [context .evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: Error?) -> Swift.Void in
                
                if success {
                    print("Authentication success")
                } else{

                    let err : LAError = LAError(_nsError: evalPolicyError! as NSError)
                    switch err.code.rawValue {
                    case LAError.systemCancel.rawValue:
                        print("Authentication was cancelled by the system")
                    case LAError.userCancel.rawValue:
                        print("Authentication was cancelled by the user")
                    case LAError.userFallback.rawValue:
                        print("User selected to enter custom password")
                    default:
                        print("Authentication failed")
                        break
                    }
                }
                
            } )]
        }
    }
}


