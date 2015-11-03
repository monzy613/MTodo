//
//  AuthenticationSetter.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/2.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticationSetter: NSObject {
    private static let userDefault = NSUserDefaults.standardUserDefaults()
    
    class func touchIdAuthentication(doAfterAuthentication: (Bool, NSError?) -> Void) {
        let laContext = LAContext()
        var error: NSError?
        
        if laContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            laContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "TouchID Authentication", reply: doAfterAuthentication)
        } else {
            print("device don't support touchId")
            error = LAError.TouchIDNotAvailable as NSError
            doAfterAuthentication(false, error)
        }
    }
    
    class func setAuthenticationSwitchUserDefault(setOn: Bool) {
        userDefault.setBool(setOn, forKey: "AuthenticationSwitch")
    }
    
    class func setPassword(password: String) {
        userDefault.setValue(password, forKey: "Password")
    }
    
    class func authenticateByPassword(password: String, onSuccess: ((Void) -> Void)?, onFail: ((Void) -> Void)?) {
        print("authenticateByPassword")
        if userDefault.stringForKey("Password") == nil {
            print("No Password in UserDefault")
            onFail
        } else {
            if let storedPassword = userDefault.stringForKey("Password") {
                if storedPassword == password {
                    print("[authenticateByPassword] success")
                    onSuccess!()
                } else {
                    print("[authenticateByPassword] failed \(storedPassword)")
                    onFail!()
                }
            }
        }
    }
    
    class func showPasswordAlert(rootViewController: UIViewController, onSuccess: ((Void) -> Void)?, onFail: ((Void) -> Void)?) {
        let passwordAlertController = UIAlertController(title: "Password", message: "Enter Password", preferredStyle: .Alert)
        passwordAlertController.addTextFieldWithConfigurationHandler() {
            textField in
            textField.secureTextEntry = true
        }
        passwordAlertController.addAction(UIAlertAction(title: "Ok", style: .Default) {
            alertAction in
            let password = passwordAlertController.textFields!.first?.text ?? ""
            if password == "" {
                showPasswordAlert(rootViewController, onSuccess: onSuccess, onFail: onFail)
            } else {
                print("authenticating password")
                authenticateByPassword(password, onSuccess: onSuccess, onFail: onFail)
            }
            })
        passwordAlertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) {
            alertAction in
            })
        rootViewController.presentViewController(passwordAlertController, animated: true, completion: nil)
    }
    
    class func showTextAlert(rootViewController: UIViewController, title: String, detail: String, onPressCancel: ((Void) -> Void)?) {
        let alertController = UIAlertController(title: title, message: detail, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {UIAlertAction in
            onPressCancel
        }))
        rootViewController.presentViewController(alertController, animated: true, completion: {})
    }
}
