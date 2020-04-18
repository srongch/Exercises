//
//  ExerciseCollectionViewCell.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit
import SDWebImage

class ExerciseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var equipment: UILabel!
    @IBOutlet weak var muscles: UILabel!
    
    var cellId: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = true
        // Initialization code
    }
    
    func configCell(model: ExerciceInforViewable){
        cellId = model.id
        loadImage(urlString: model.mainImage)
        categoryLabel.text = model.categoryName
        nameLabel.text = model.name
        equipment.text = model.equimentsList
        muscles.text = model.musclesList
        
    }
    
    private func loadImage(urlString: String?){
        guard let url = URL(string: urlString ?? "") else {
            imageView.image = UIImage(named: "placeholder")
            return
        }
        print(url.absoluteString)
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
    
    func updateImage(urlString: String, for cellId: Int){
        guard cellId == self.cellId else {return}
        self.loadImage(urlString: urlString)
    }

}
