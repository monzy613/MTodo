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
    class func touchIdAuthentication(doAfterAuthentication: (Bool, NSError?) -> Void) {
        let laContext = LAContext()
        var error: NSError?
        
        if laContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            laContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "TouchID Authentication", reply: doAfterAuthentication)
        } else {
            print("device don't support touchId")
        }
    }
    
    class func setAuthenticationSwitchUserDefault(setOn: Bool) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setBool(setOn, forKey: "AuthenticationSwitch")
    }
}
