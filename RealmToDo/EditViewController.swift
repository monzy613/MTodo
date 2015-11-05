//
//  EditViewController.swift
//  RealmToDo
//
//  Created by Monzy on 15/11/2.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextViewDelegate {
    
    //Mark outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    let offset_for_keyboard: CGFloat = 80.0
    var dismissKeyboardButton: UIButton?
    var keyboardHeight: CGFloat = 250
    var originalTextViewFrame: CGRect?
    var limitY: CGFloat?
    var contentViewOffset: CGFloat = 0
    var visibleTextViewHeight: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contentTextView.delegate = self
        configAutoScrolling()
    }
    
    func configAutoScrolling() {
        originalTextViewFrame = contentTextView.frame
        configDismissKeyboardButton()
    }
    
    func configDismissKeyboardButton() {
        let buttonWidth: CGFloat = keyboardHeight / 6
        let buttonHeight: CGFloat = buttonWidth * 2 / 3
        let startX: CGFloat = 3
        let startY: CGFloat = self.view.frame.height - buttonHeight
        let originFrame = CGRect(x: startX, y: startY, width: buttonWidth, height: buttonHeight)
        dismissKeyboardButton = UIButton(type: .System)
        dismissKeyboardButton?.frame = originFrame
        dismissKeyboardButton?.imageView?.contentMode = .ScaleAspectFit
        dismissKeyboardButton?.setImage(UIImage(named: "keyboard_189px"), forState: .Normal)
        dismissKeyboardButton?.addTarget(self, action: "moveDownDismissKeyboardButton", forControlEvents: .TouchUpInside)
        dismissKeyboardButton?.alpha = 0
        self.view.addSubview(dismissKeyboardButton!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func moveUpDismissKeyboardButton(keyboardFrame: CGRect) {
        var newFrame = dismissKeyboardButton?.frame
        newFrame?.origin.y = self.view.frame.height - keyboardFrame.height - 3 - newFrame!.height
        dismissKeyboardButton?.frame = newFrame!
        dismissKeyboardButton?.alpha = 1
    }
    
    func moveDownDismissKeyboardButton() {
        self.view.endEditing(true)
        var newFrame = dismissKeyboardButton?.frame
        let startY: CGFloat = self.view.frame.height - ((newFrame?.height)! - 3)
        newFrame?.origin.y = startY
        UIView.animateWithDuration(0.1, animations: {
            self.dismissKeyboardButton?.frame = newFrame!
            self.dismissKeyboardButton?.alpha = 0
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("save note")
        if contentTextView.text == "" && titleTextField.text == "" {
            return
        }
        let note = Note()
        note.title = titleTextField.text!
        note.createdAt = NSDate()
        note.content = contentTextView.text
        if contentTextView.text != "" && titleTextField.text == "" {
            note.title = ""
        } else if contentTextView.text == "" && titleTextField.text != ""{
            note.content = ""
        }
        do {
            try uiRealm.write(){
                uiRealm.add(note)
            }
        } catch {
            print("exception in editing: \(error)")
        }
    }

    
    
    func textViewDidBeginEditing(textView: UITextView) {
        print("textViewDidBeginEditing")
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        print("textViewDidEndEditing")
    }
    
    func textViewDidChange(textView: UITextView) {
        scrollToCursor()
    }
    
    //Mark keyboard show and hide
    func keyboardWillShow(notification: NSNotification) {
        let userinfo = notification.userInfo
        let rawFrame = (userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardFrame = self.view.convertRect(rawFrame, fromView: nil)
        keyboardHeight = keyboardFrame.height
        print("keyboardWillShow, keybordFrame: \(keyboardFrame)")
        moveUpDismissKeyboardButton(keyboardFrame)
        if limitY == nil || getCursorY() < limitY {
            limitY = (dismissKeyboardButton?.frame.origin.y)!
        }
        
        if visibleTextViewHeight == nil {
            let height = (dismissKeyboardButton?.frame.origin.y)!
            let lineHeight = contentTextView.font?.lineHeight
            visibleTextViewHeight = 0
            while true {
                visibleTextViewHeight! += lineHeight!
                if visibleTextViewHeight > height {
                    visibleTextViewHeight! -= lineHeight!
                    break
                }
            }
            
            print("visibleTextViewHeight: \(visibleTextViewHeight!), height: \(height)")
        }
        scrollToCursor()
    }
    
    
    func keyboardWillHide() {
        print("keyboardWillHide")
        //contentTextView.setContentOffset(CGPoint(x: 0, y: contentViewOffset), animated: true)
        limitY! = (dismissKeyboardButton?.frame.origin.y)!
    }
    
    func resetView() {
        print("resetView")
        var rect = contentTextView.frame
        rect.origin.y = (originalTextViewFrame?.origin.y)!
        UIView.animateWithDuration(0.25, animations: {
            self.contentTextView.frame = rect
        })
    }
    
    
    func scrollToCursor() {
        if contentTextView.selectedRange.location != NSNotFound {
            let cursorY = getCursorY()
            if cursorY > limitY! {
                let lineHeight = (contentTextView.font?.lineHeight)!
                redirectLimitY(cursorY, lineHeight: lineHeight)
                contentViewOffset = cursorY - visibleTextViewHeight!
                print("cursorY: \(cursorY), limitY: \(limitY!), contentTextViewOffset: \(contentViewOffset)")
                self.contentTextView.setContentOffset(CGPoint(x: 0, y: self.contentViewOffset), animated: false)
            }
        }
    }
    
    func redirectLimitY(cursorY: CGFloat, lineHeight: CGFloat) {
        if limitY != nil {
            while limitY < cursorY {
                limitY! += lineHeight
            }
        }
    }
    
    
    func getCursorY() -> CGFloat {
        var range = NSRange()
        range.location = contentTextView.selectedRange.location
        range.length = contentTextView.text.characters.count - range.location
        let str = (contentTextView.text as NSString).stringByReplacingCharactersInRange(range, withString: "") as NSString
        let size = str.boundingRectWithSize(contentTextView.bounds.size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: contentTextView.font!], context: nil)
        return size.height + contentTextView.frame.origin.y
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
