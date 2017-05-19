//
//  MemeTableVC.swift
//  MemeMe
//
//  Created by Yeontae Kim on 5/12/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailTopText: UILabel!
    @IBOutlet weak var thumbnailBottomText: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailTitle: UILabel!
    
}

class MemeTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var memes = [Meme]()
    
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    let titleTextAttributes: [String:Any] = [
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "impact", size: 15)!,
        NSStrokeColorAttributeName: UIColor.black,
        NSStrokeWidthAttributeName: -3.6,
        ]
    
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
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = true
//    }
    

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! MemeTableViewCell
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
        
        cell.thumbnailTitle?.text = cellTopText + "..." + cellBottomText
        cell.thumbnailImageView?.image = meme.originalImage
        cell.thumbnailTopText.attributedText = NSMutableAttributedString(string: cellTopText, attributes: titleTextAttributes)
        cell.thumbnailBottomText.attributedText = NSMutableAttributedString(string: cellBottomText, attributes: titleTextAttributes)
    
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        let selectedIndex = (indexPath as NSIndexPath).row
        
        detailController.memes = self.memes
        detailController.meme = self.memes[selectedIndex]
        detailController.selectedIndex = selectedIndex
        
        let rightBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: detailController, action: #selector(detailController.editButtonTapped(_:)))
        detailController.navigationItem.rightBarButtonItem = rightBarButton
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    @IBAction func addMemeButtonTapped(_ sender: UIBarButtonItem) {
       
        // present MemeEditorVC with current meme info
        let editorController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        
        editorController.memes = self.memes
        
        self.navigationController!.pushViewController(editorController, animated: true)
        
    }

}
