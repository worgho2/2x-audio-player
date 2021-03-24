//
//  RightDetailTableViewCell.swift
//  2xSpeedAudio
//
//  Created by otavio on 10/02/21.
//

import UIKit

class RightDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(image: UIImage, title: String, detail: String) {
        self.titleLabel.text = title
        self.leftImageView.image = image
        self.detailLabel.text = detail
    }
    
}
