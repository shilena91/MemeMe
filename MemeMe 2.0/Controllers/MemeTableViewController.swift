//
//  MemeTableViewController.swift
//  MemeMe 2.0
//
//  Created by Hoang on 31.3.2020.
//  Copyright © 2020 Hoang. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false

        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    @objc func addImage() {
        if let vc = storyboard?.instantiateViewController(identifier: "MemeImageVC") as? MemeImageViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath) as! MemeTableViewCell

        cell.tableViewCellImage = memes[indexPath.row].memeImage
        cell.label = "\(memes[indexPath.row].topText)...\(memes[indexPath.row].bottomText)"
        cell.loadCellContent()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "showImageVC") as! showImageIdViewController
        vc.image = memes[indexPath.row].memeImage
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
