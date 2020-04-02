//
//  MemeTableViewCell.swift
//  MemeMe 2.0
//
//  Created by Hoang on 1.4.2020.
//  Copyright © 2020 Hoang. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewCellImageView: UIImageView!
    
    @IBOutlet weak var tableViewCellLabel: UILabel!
    
    var tableViewCellImage: UIImage!
    var label: String!
    
    func loadCellContent() {
        tableViewCellImageView.image = tableViewCellImage
        tableViewCellLabel.text = label
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
