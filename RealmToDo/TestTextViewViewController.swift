//
//  TestTextViewViewController.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/3.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class TestTextViewViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.delegate = self
        textView.delegate = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidChange(textView: UITextView) {
        print("textView did change")
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("textField did beginEditing")
    }
    
    @IBAction func showMenu(sender: UIButton) {
        performSegueWithIdentifier("sw_rear", sender: self)
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
