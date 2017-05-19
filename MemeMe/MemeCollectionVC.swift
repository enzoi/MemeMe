//
//  MemeCollectionVC.swift
//  MemeMe
//
//  Created by Yeontae Kim on 5/12/17.
//  Copyright © 2017 YTK. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MemeCollectionVC: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let titleTextAttributes: [String:Any] = [
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "impact", size: 15)!,
        NSStrokeColorAttributeName: UIColor.black,
        NSStrokeWidthAttributeName: -3.6,
        ]
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")

        // Do any additional setup after loading the view.
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = true
//    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! MemeCollectionViewCell
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
        
        cell.thumbnailImageView?.image = meme.originalImage
        cell.thumbnailTopText.attributedText = NSMutableAttributedString(string: cellTopText, attributes: titleTextAttributes)
        cell.thumbnailBottomText.attributedText = NSMutableAttributedString(string: cellBottomText, attributes: titleTextAttributes)
        
        // Set the collection view image
        cell.thumbnailImageView?.image = meme.originalImage
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
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
