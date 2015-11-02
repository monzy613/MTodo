//
//  EditViewController.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/2.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    //Mark outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("save note")
        if contentTextView.text == "" && titleTextField.text == "" {
            return
        }
        
        let note = Note(value: [titleTextField.text, "now", contentTextView.text])
        if contentTextView.text != "" && titleTextField.text == "" {
            note.name = "no title"
        } else if contentTextView.text == "" && titleTextField.text != ""{
            note.note = "no content"
        }
        do {
            try uiRealm.write(){
                uiRealm.add(note)
            }
        } catch {
            print("exception in editing: \(error)")
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
