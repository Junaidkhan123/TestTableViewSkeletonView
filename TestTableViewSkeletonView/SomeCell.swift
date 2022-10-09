//
//  SomeCell.swift
//  TestTableViewSkeletonView
//
//  Created by Junaid on 09/10/2022.
//

import UIKit

class SomeCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatar.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
