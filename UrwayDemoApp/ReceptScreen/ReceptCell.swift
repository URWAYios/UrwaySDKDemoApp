//
//  ReceptCell.swift
//  UrwayDemoApp
//

import UIKit

class ReceptCell: UITableViewCell {

    
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTitle(title: String) {
        self.titleLabel.text = title
    }
    
}
