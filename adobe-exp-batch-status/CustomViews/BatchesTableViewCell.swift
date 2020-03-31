//
//  BatchesTableViewCell.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import UIKit

class BatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var batchIdLabel: UILabel!
    @IBOutlet weak var lastModifiedLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusColorView.layer.cornerRadius = (statusColorView.bounds.width) / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
