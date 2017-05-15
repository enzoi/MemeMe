//
//  MemeDetailVC.swift
//  MemeMe
//
//  Created by Yeontae Kim on 5/14/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        // present meme image
        self.imageView!.image = self.meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
        // present MemeEditorVC with current meme info
        let editorController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        // pass data 
        editorController.topTextField.text = self.meme.topText
        editorController.imagePickerView.image = self.meme.memedImage
        editorController.bottomTextField.text = self.meme.bottomText
        
        self.present(editorController, animated: true, completion: nil)
        
    }
    
}