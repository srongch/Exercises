//
//  TitleCollectionViewCell.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String, subTitle: String){
        self.title.text = title
        self.subTitle.text = subTitle
    }

}
