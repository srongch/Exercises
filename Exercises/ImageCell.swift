//
//  ImageCell.swift
//  Gallery
//
//  Created by Dumbo on 14/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let reuseIdentifer = "album-item-cell-reuse-identifier"
    var featuredPhotoView = UIImageView()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCell{
    func configure() {
        
        contentView.addSubview(featuredPhotoView)
        featuredPhotoView.contentMode = .scaleAspectFill
        
        featuredPhotoView.translatesAutoresizingMaskIntoConstraints = false
        featuredPhotoView.backgroundColor = .gray
        featuredPhotoView.image = UIImage(named: "waiting")
        
        featuredPhotoView.layer.cornerRadius = 10
        featuredPhotoView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            featuredPhotoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            featuredPhotoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            featuredPhotoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            featuredPhotoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func loadImage(image: UIImage?){
//        guard let image = image else {
//            fatalError()
//        }
        print("set image : \(image)")
        self.featuredPhotoView.image = image == nil ? UIImage(named: "waiting") : image
        self.featuredPhotoView.contentMode = image == nil ? .center : .scaleAspectFill
    }
}
