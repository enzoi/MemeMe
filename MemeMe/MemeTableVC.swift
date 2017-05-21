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
    var deleteMemeIndexPath: NSIndexPath? = nil
    
    @IBOutlet var tableView: UITableView!
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

        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    // swipe to delete function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteMemeIndexPath = indexPath as NSIndexPath
            let memeToDelete = self.memes[indexPath.row]
            confirmDelete(meme: memeToDelete)
        }
    }
    
    func confirmDelete(meme: Meme) {
        let alert = UIAlertController(title: "Delete Meme", message: "Are you sure you want to permanently delete the selected meme?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteMeme)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteMeme)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteMeme(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteMemeIndexPath {
            self.tableView.beginUpdates()
            
            memes.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            self.tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            
            deleteMemeIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteMeme(alertAction: UIAlertAction!) {
        deleteMemeIndexPath = nil
    }

    @IBAction func addMemeButtonTapped(_ sender: UIBarButtonItem) {
       
        // present MemeEditorVC with current meme info
        let editorController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorVC
        
        editorController.memes = self.memes
        
        self.navigationController!.pushViewController(editorController, animated: true)
        
    }

}
