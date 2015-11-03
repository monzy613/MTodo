//
//  ShowViewController.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/2.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {

    var note = Note()
    var previousContent = ""
    var isModified = false
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = note.title
        previousContent = note.content
        contentTextView.text = note.content
        titleTextField.text = note.title
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        do {
            try uiRealm.write() {
                self.note.title = self.titleTextField.text ?? self.note.title
                self.note.content = self.contentTextView.text
            }
        } catch {
            print("error writing realm: \(error)")
        }
    }
    

    @IBAction func titleEdited(sender: UITextField) {
        isModified = true
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
