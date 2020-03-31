//
//  ErrorDetailsTableViewCell.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 3/19/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import UIKit

class ErrorDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var errorCodeLabel: UILabel!
    @IBOutlet weak var errorCodeDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
