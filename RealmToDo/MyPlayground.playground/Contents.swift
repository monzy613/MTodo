//: Playground - noun: a place where people can play

import UIKit
import LocalAuthentication

var str = "Hello, playground"


LAError.AppCancel.rawValue
LAError.AuthenticationFailed.rawValue
LAError.InvalidContext.rawValue
LAError.PasscodeNotSet.rawValue
LAError.SystemCancel.rawValue
LAError.TouchIDLockout.rawValue
LAError.TouchIDNotAvailable.rawValue
LAError.TouchIDNotEnrolled.rawValue
LAError.UserCancel.rawValue
LAError.UserFallback.rawValue

var touchIdSwitch = UISwitch()
touchIdSwitch.setOn(true, animated: true)
UIButtonType.Custom.rawValue