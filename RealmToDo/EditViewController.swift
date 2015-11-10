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
    var doneButton: MZFloatButton?
    let offset_for_keyboard: CGFloat = 80.0
    var dismissKeyboardButton: UIButton?
    var keyboardHeight: CGFloat = 250
    var originalTextViewFrame: CGRect?
    var limitY: CGFloat?
    var contentViewOffset: CGFloat = 0
    var lineHeightOffset: CGFloat = 2
    var visibleTextViewHeight: CGFloat?
    var lineHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contentTextView.delegate = self
        configAutoScrolling()
        configDoneButton()
    }
    
    func configAutoScrolling() {
        lineHeight = (contentTextView.font?.lineHeight)! + lineHeightOffset
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
    
    func configDoneButton() {
        doneButton = MZFloatButton().configure(self.view, _percent: 0.15, _image: UIImage(named: "done"), _title: nil, _backgroundColor: nil, _toggleDuration: 0.1)
        doneButton?.toggle()
        doneButton?.addTarget(self, action: "dismissViewController", forControlEvents: .TouchUpInside)
    }
    
    func dismissViewController() {
        doneButton?.hide()
        self.dismissViewControllerAnimated(true, completion: {})
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
        //scrollToCursor()
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        scrollToCursor()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
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
            visibleTextViewHeight = 0
            while true {
                visibleTextViewHeight! += lineHeight
                if visibleTextViewHeight > height {
                    visibleTextViewHeight! -= lineHeight
                    break
                }
            }
            
            print("visibleTextViewHeight: \(visibleTextViewHeight!), height: \(height)")
        }
        scrollToCursor()
    }
    
    
    func keyboardWillHide() {
        moveDownDismissKeyboardButton()
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
//            if cursorY > limitY! {
            redirectLimitY(cursorY)
            contentViewOffset = cursorY - visibleTextViewHeight!
            if contentViewOffset <= 0 {
                return
            }
            let superFrame = contentTextView.frame
            let frame = CGRect(x: superFrame.origin.x, y: superFrame.origin.y, width: superFrame.width, height: superFrame.height + lineHeight)
            print("cursorY: \(cursorY), limitY: \(limitY!), contentTextViewOffset: \(contentViewOffset), lineHeight: \(lineHeight)")
            contentTextView.frame = frame
            contentTextView.setContentOffset(CGPoint(x: 0, y: self.contentViewOffset), animated: false)
//            }
        }
    }
    
    func redirectLimitY(cursorY: CGFloat) {
        if limitY != nil {
            while limitY < cursorY {
                limitY! += lineHeight
            }
        }
    }
    
    func getCursorY() -> CGFloat {
        let contentString = contentTextView.text as NSString
        var range = NSMakeRange(contentString.length, 0)
        range.location = contentTextView.selectedRange.location
        range.length = contentString.length - range.location
        print("range: \(range)")
        let str = contentString.stringByReplacingCharactersInRange(range, withString: "") as NSString
        let size = str.boundingRectWithSize(contentTextView.bounds.size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: contentTextView.font!], context: nil)
        let cursorHeight = size.height + contentTextView.frame.origin.y
        print("size.height: \(size.height)")
        return cursorHeight
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
