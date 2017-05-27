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
        
        self.tabBarController?.tabBar.isHidden = true
        // present meme image
        self.imageView!.image = self.meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
        // present MemeEditorVC with current meme info
        let editorVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC

        editorVC.memes = self.memes
        editorVC.selectedIndex = self.selectedIndex

        let navController = UINavigationController(rootViewController: editorVC)
        
        present(navController, animated: true, completion: nil)
    }
    
}
