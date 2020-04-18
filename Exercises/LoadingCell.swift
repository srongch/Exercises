//
//  LoadingCell.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionViewCell {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingView.hidesWhenStopped = true
        // Initialization code
    }
    
    func loading(finish: Bool){
        finish ? loadingView.stopAnimating() : self.loadingView.startAnimating()
        
    }

}
