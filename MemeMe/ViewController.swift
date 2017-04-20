//
//  ViewController.swift
//  MemeMe
//
//  Created by Yeontae Kim on 4/17/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!

    let textFieldAttributes: [String:Any] = [
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 40)!,
        NSStrokeColorAttributeName: UIColor.black,
        NSStrokeWidthAttributeName: -3,
        ]
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: textFieldAttributes)
        topTextField.defaultTextAttributes = textFieldAttributes
        topTextField.textAlignment = .center
        topTextField.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: textFieldAttributes)
        bottomTextField.defaultTextAttributes = textFieldAttributes
        bottomTextField.textAlignment = .center
        bottomTextField.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
    
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePickerView.image = image
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.attributedPlaceholder = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == topTextField {
            topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: textFieldAttributes)
        } else { // bottomTextField
            bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: textFieldAttributes)
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        self.view.frame.origin.y = 0 - getKeyboardHeight(notification)
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        self.view.frame.origin.y += getKeyboardHeight(notification)
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    
    }
    

}


