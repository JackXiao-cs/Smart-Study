//
//  CustomizeCollectionViewCell.swift
//  StudyApp_v.2
//
//  Created by Jack Xiao on 11/9/20.
//

//create a editable cell for Collection cells in flash cards view. 
import UIKit

class CustomizeCollectionViewCell: UICollectionViewCell {

    @IBOutlet var Answertext: UILabel!
    @IBOutlet var Questiontext: UILabel!
    @IBOutlet var Edit: UIButton!
    @IBOutlet var Image: UIImageView!
    
    
    
    static let identifier = "CustomizeCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "CustomizeCollectionViewCell", bundle: nil)
    }

}
