//
//  SharePackageCell.swift
//  ShipIt-iMessage
//
//  Created by David Retegan on 06.01.2023.
//

import UIKit

class SharePackageCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var packageIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 15.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
