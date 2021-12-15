//
//  TaskCell.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 13.12.2021.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var cellContent: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContent.layer.cornerRadius = cellContent.frame.size.height / 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        cellContent.frame = cellContent.frame.inset(by: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0))
    }
}
