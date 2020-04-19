//
//  ImageCollectionViewCell.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 15.0
        self.imageView.layer.masksToBounds = true
        // Initialization code
    }
    
    func configure(imageUrl: String?){
        guard let url = URL(string: imageUrl ?? "") else {
            imageView.image = UIImage(named: "placeholder")
            return
        }
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }

}
