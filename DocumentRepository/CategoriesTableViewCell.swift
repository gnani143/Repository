//
//  CategoriesTableViewCell.swift
//  DocumentRepository
//
//  Created by Gnani on 8/12/17.
//  Copyright © 2017 Gnani. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var numofDocs: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
