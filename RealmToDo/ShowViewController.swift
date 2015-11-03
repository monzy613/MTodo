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
        title = note.name
        previousContent = note.note
        contentTextView.text = note.note
        titleTextField.text = note.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        do {
            try uiRealm.write() {
                let newNote = Note(value: ["name": self.titleTextField.text ?? self.note.name, "note": self.contentTextView.text])
                uiRealm.delete(self.note)
//                self.note.name = self.titleTextField.text ?? self.note.name
//                self.note.note = self.contentTextView.text
                uiRealm.add(newNote)
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
