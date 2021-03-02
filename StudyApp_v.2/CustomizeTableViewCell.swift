//
//  CustomizeTableViewCell.swift
//  StudyApp_v.2
//
//  Created by Jack Xiao
//


// creates a editable  Cell for TableView
import UIKit

class CustomizeTableViewCell: UITableViewCell {
    @IBOutlet weak var CellTitle: UILabel!
    @IBOutlet weak var CellDetails: UILabel!
    @IBOutlet weak var CellColor: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }

}
