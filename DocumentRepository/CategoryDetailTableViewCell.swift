//
//  CategoryDetailTableViewCell.swift
//  DocumentRepository
//
//  Created by Gnani on 8/12/17.
//  Copyright © 2017 Gnani. All rights reserved.
//

import UIKit

class CategoryDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filesizeLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
