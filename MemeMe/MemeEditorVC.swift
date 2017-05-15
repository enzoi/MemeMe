//
//  MemeEditorVC.swift
//  MemeMe
//
//  Created by Yeontae Kim on 4/17/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let textFieldAttributes: [String:Any] = [
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "impact", size: 40)!,
        NSStrokeColorAttributeName: UIColor.black,
        NSStrokeWidthAttributeName: -3.6,
        ]
    
    var imagePicker: UIImagePickerController!
    var memes = [Meme]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
    
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        textField.delegate = self
        textField.defaultTextAttributes = textFieldAttributes
        textField.attributedPlaceholder = NSAttributedString(string: defaultText, attributes: textFieldAttributes)
        textField.textAlignment = .center
    }
    
    // Hide Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        // The Camera button is disabled when app is run on devices without a camera, such as the simulator
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            cameraButton.isEnabled = true
        } else {
            cameraButton.isEnabled = false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
    
        pick(sourceType: .photoLibrary)
        
    }
    
    @IBAction func takeAPhoto(_ sender: Any) {
        
        pick(sourceType: .camera)
        
    }
    
    func pick(sourceType: UIImagePickerControllerSourceType) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePickerView.image = image
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        textField.attributedPlaceholder = nil
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == topTextField {
            prepareTextField(textField: topTextField, defaultText: "TOP")
        } else { // bottomTextField
            prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
        }
        
        textField.resignFirstResponder()
        
        return false
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }

    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
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
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        navigationController?.setNavigationBarHidden(true, animated: false)
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        navigationController?.setNavigationBarHidden(false, animated: false)
        toolBar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func shareImageButton(_ sender: Any) {
        
        var memedImage: UIImage?
        
        func save() {
            // Create the meme
            let meme = Meme(topText: topTextField.text!,
                            bottomText: bottomTextField.text!,
                            originalImage: imagePickerView.image!,
                            memedImage: memedImage)
            self.memes.append(meme)
        }
        
        if imagePickerView.image != nil {
        
            memedImage = generateMemedImage()
            
            let activityViewController = UIActivityViewController(activityItems: [ memedImage! ], applicationActivities: nil)
            // present the view controller
            present(activityViewController, animated: true, completion: nil)
            
            activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                if (completed) {
                    save()
                    self.dismiss(animated: true, completion: nil)
                }
                
                // Get the storyboard and MemeTableViewController
                let storyboard = UIStoryboard (name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                
                // Communicate the memes
                // memeTableVC.memes = self.memes
                
                // programmatically push view controller
                self.present(tabBarController, animated: true, completion: nil)
                
            }
            
            
        } else {
            
            let alert = UIAlertController(title: "Alert",
                                          message: "Please select an image from photo library or camera",
                                          preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
 
            })
            
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
    
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        // go back to placeholder text, no image when cancel button tapped
        topTextField.text = ""
        bottomTextField.text = ""
        imagePickerView.image = nil
           
    }

}
