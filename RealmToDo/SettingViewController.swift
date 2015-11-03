//
//  SettingViewController.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/2.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingViewController: UIViewController {

    @IBOutlet var touchIdSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("switcher state: \(touchIdSwitch.on)")
        initSwitchState()
        // Do any additional setup after loading the view.
    }
    
    func initSwitchState() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        if userDefault.objectForKey("AuthenticationSwitch") == nil {
            AuthenticationSetter.setAuthenticationSwitchUserDefault(false)
            touchIdSwitch.setOn(false, animated: false)
            print("AuthenticationSwitch set")
        } else {
            touchIdSwitch.setOn(userDefault.boolForKey("AuthenticationSwitch"), animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToMain(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func swichTouchIdState(sender: UISwitch) {
        print("newState:\(sender.on)")
        if sender.on == false {
            AuthenticationSetter.touchIdAuthentication() {
                isSuccess, error in
                if isSuccess == true {
                    AuthenticationSetter.setAuthenticationSwitchUserDefault(false)
                } else {
                    sender.setOn(true, animated: true)
                }
                if let laError = error as? LAError {
                    print("error happened in authenticating: \(laError)")
                    switch laError {
                    case .AppCancel:
                        print("App Cancel")
                        self.touchIdSwitch.setOn(true, animated: true)
                        break
                    case .SystemCancel:
                        print("System Cancel")
                        self.touchIdSwitch.setOn(true, animated: true)
                        break
                    case .UserCancel:
                        print("User Cancel")
                        dispatch_async(dispatch_get_main_queue()) {
                            self.touchIdSwitch.setOn(self.touchIdSwitch.on, animated: false)
                        }
                        break
                    default:
                        break
                    }
                } else {
                    print("no error")
                }
            }
        } else {
            AuthenticationSetter.setAuthenticationSwitchUserDefault(true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
