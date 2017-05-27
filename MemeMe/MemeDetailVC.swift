//
//  MemeDetailVC.swift
//  MemeMe
//
//  Created by Yeontae Kim on 5/14/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {

    var memes = [Meme]()
    var meme: Meme!
    var selectedIndex: Int!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if (movetoroot) {
//            _ = navigationController?.popToRootViewController(animated: true)
//        } else {
//            _ = navigationController?.popViewController(animated: true)
//        }
        
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
        let editorVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        // pass data
        editorVC.memes = self.memes
        editorVC.selectedIndex = self.selectedIndex
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(editorVC.cancelButtonTapped(_:)))
        editorVC.navigationItem.rightBarButtonItem  = cancelButton
        let navController = UINavigationController(rootViewController: editorVC)
        
        // show MemeEditorVC modally
        self.present(navController, animated: true, completion: nil)
    }
    
}
