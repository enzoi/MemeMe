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
    @IBOutlet weak var shareImageButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let textFieldAttributes: [String:Any] = [
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "impact", size: 40)!,
        NSStrokeColorAttributeName: UIColor.black,
        NSStrokeWidthAttributeName: -3.6,
        ]
    
    var imagePicker: UIImagePickerController!
    var memes = [Meme]()
    var selectedIndex: Int?
    
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
    
    // hide Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
        
        // populate editor when a meme sent from MemeDetailVC
        if self.selectedIndex != nil {
            self.topTextField.text = self.memes[selectedIndex!].topText
            self.imagePickerView.image = self.memes[selectedIndex!].originalImage
            self.bottomTextField.text = self.memes[selectedIndex!].bottomText
        }
        
        // the camera button is disabled when app is run on devices without a camera, such as the simulator
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            cameraButton.isEnabled = true
        } else {
            cameraButton.isEnabled = false
        }
        
        // share image button is disabled when there is no image selected from album or camera
        if imagePickerView.image == nil {
            shareImageButton.isEnabled = false
        } else {
            shareImageButton.isEnabled = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = false
        self.selectedIndex = nil
        
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
            // create a meme by using Meme model
            let meme = Meme(topText: topTextField.text!,
                            bottomText: bottomTextField.text!,
                            originalImage: imagePickerView.image!,
                            memedImage: memedImage)
            
            // add the saved meme to memes array or replace it with the edited meme
            if self.selectedIndex == nil {
                // new meme added to memes array
                self.memes.append(meme)
            } else {
                // replace existing meme when the meme is sent from detailVC for editing
                self.memes[selectedIndex!] = meme
            }
        }
        
        if imagePickerView.image != nil {
        
            memedImage = generateMemedImage()
            
            let activityViewController = UIActivityViewController(activityItems: [ memedImage! ], applicationActivities: nil)
            
            // present the view controller
            present(activityViewController, animated: true, completion: nil)
            
            activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                if (completed) {
                    save()

                    if let tabBarController = self.presentingViewController as? MemeTabBarController {
                        tabBarController.memes = self.memes

                        self.dismiss(animated: true, completion: nil)
                        
                    }

                }
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
        
        dismiss(animated: true, completion: nil)
        
    }


}


