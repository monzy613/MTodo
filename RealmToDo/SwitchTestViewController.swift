//
//  SwitchTestViewController.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/3.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class SwitchTestViewController: UIViewController {

    @IBOutlet var switcher: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        switcher.setOn(!switcher.on, animated: false)
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
