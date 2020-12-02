//
//  BasicTableViewCell.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import UIKit

class BasicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(image: UIImage, title: String) {
        self.titleLabel.text = title
        self.leftImageView.image = image
    }
    
}
