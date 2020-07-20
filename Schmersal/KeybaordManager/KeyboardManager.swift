//
//  File.swift
//  Schmersal
//
//  Created by Ankit on 07/07/20.
//  Copyright © 2020 Ankit. All rights reserved.
//

import Foundation
import UIKit


class KeyboardManager : UITextField, UITextFieldDelegate  {
    var vc:UIViewController?
    var activeTxtFiled:UITextField?
    
    func registerObserver(vController:UIViewController) {
        self.vc = vController
        if let txt = (vc?.view.viewWithTag(1) as? UITextField) {
            txt.delegate = self
        }
        if let txt = (vc?.view.viewWithTag(2) as? UITextField) {
            txt.delegate = self
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var offsetVal = (activeTxtFiled?.superview?.superview?.frame.origin.y ?? 0) + (activeTxtFiled?.superview?.frame.origin.y ?? 0) + 60
            offsetVal = (self.vc?.view.frame.size.height)! - offsetVal
            if offsetVal < keyboardSize.height {
                UIView.animate(withDuration: 0.2, animations: {
                    self.vc?.view.frame.origin.y = -(keyboardSize.height - offsetVal)
                })
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if vc?.view.frame.origin.y != 0 {
            vc?.view.frame.origin.y = 0
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTxtFiled = textField
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        activeTxtFiled = textField
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField.tag == 1 {
            vc?.view.viewWithTag(2)?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    func removeObserver() {
        NotificationCenter.default.removeObserver((Any).self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver((Any).self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

