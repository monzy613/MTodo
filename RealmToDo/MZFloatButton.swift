//
//  MZFloatButton.swift
//  FloatBottomButton
//
//  Created by Monzy on 15/11/9.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit


class MZFloatButton: UIButton {
    
    var offset: CGFloat = 20
    var isShow = false
    var toggleDuration: NSTimeInterval = 0.25
    var showFrame: CGRect = CGRect()
    var hideFrame: CGRect = CGRect()
    
    func configure(_rootView: UIView, _percent: CGFloat?, _image: UIImage?, _title: String?, _backgroundColor: UIColor?, _toggleDuration: NSTimeInterval?) -> MZFloatButton {
        let superFrame = _rootView.frame
        self.setImage(_image, forState: .Normal)
        self.backgroundColor = backgroundColor
        self.setTitle(_title, forState: .Normal)
        if self.imageView != nil {
            self.imageView?.contentMode = .ScaleAspectFit
        }
        var percent: CGFloat = 0.15
        if _percent != nil {
            if _percent > 0 && _percent <= 1 {
                percent = _percent!
            }
        }
        toggleDuration = _toggleDuration ?? 0.25
        let showWidth = superFrame.width * percent
        let hideWidth = showWidth * 2 / 3
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        let showX = (superFrame.width - showWidth) / 2
        let showY = superFrame.height - showWidth - offset
        let hideX = (superFrame.width - hideWidth) / 2
        let hideY = superFrame.height
        _rootView.addSubview(self)
        hideFrame = CGRect(x: hideX, y: hideY, width: hideWidth, height: hideWidth)
        showFrame = CGRect(x: showX, y: showY, width: showWidth, height: showWidth)
        self.frame = hideFrame
        self.alpha = 0.6
        return self
    }
    
    func show() {
        if superview == nil || isShow == true {
            return
        }
        UIView.animateWithDuration(toggleDuration, animations: {
            self.frame = self.showFrame
            },
            completion: {
                complete in
                self.isShow = true
            }
        )
    }
    
    func hide() {
        if superview == nil || isShow == false {
            return
        }
        UIView.animateWithDuration(toggleDuration, animations: {
            self.frame = self.hideFrame
            },
            completion: {
                complete in
                self.isShow = false
            }
        )
    }
    
    func toggle() {
        if superview == nil {
            return
        }
        if isShow {
            hide()
        } else {
            show()
        }
        
    }
    
}
