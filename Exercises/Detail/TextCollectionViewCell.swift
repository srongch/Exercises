//
//  TextCollectionViewCell.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit
enum TextCellStyle {
    case multiLine
    case oneLine
    var numberOfLine: Int {
        switch self {
        case .multiLine:
            return 0
        default:
            return 1
        }
    }
    
    var cornerRedius: CGFloat {
        switch self {
        case .multiLine:
            return 0.0
        default:
            return 10.0
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .multiLine:
            return .clear
        default:
            return .secondarySystemBackground
        }
    }
    
    var extraSpace: String{
        switch self {
        case .multiLine:
            return ""
        default:
            return "   "
        }
    }
}
class TextCollectionViewCell: UICollectionViewCell {


    
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.layer.masksToBounds = true
        // Initialization code
    }
    
    func configure(text: String, style: TextCellStyle){
        self.label.text = style.extraSpace + text + style.extraSpace
        self.label.numberOfLines = style.numberOfLine
        self.label.layer.cornerRadius = style.cornerRedius
        self.label.backgroundColor = style.bgColor
    }
    
}
