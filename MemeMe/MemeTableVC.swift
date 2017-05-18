//
//  MemeTableVC.swift
//  MemeMe
//
//  Created by Yeontae Kim on 5/12/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class MemeTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let meme = self.memes[(indexPath as NSIndexPath).row]
        var cellTopText = meme.topText
        var cellBottomText = meme.bottomText
        
        // Set the name and image
        if cellTopText == "" {
            cellTopText = "TOP"
        }
        
        if cellBottomText == "" {
            cellBottomText = "BOTTOM"
        }
        
        cell.textLabel?.text = cellTopText + "..." + cellBottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: Selector(("editButtonTapped")))
        detailController.navigationItem.rightBarButtonItem = edit
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    @IBAction func addMemeButtonTapped(_ sender: UIBarButtonItem) {
       
        // present MemeEditorVC with current meme info
        let editorController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        
        editorController.memes = self.memes
        
        self.navigationController!.pushViewController(editorController, animated: true)
        
    }

}
