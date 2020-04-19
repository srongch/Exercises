//
//  FilterViewCell.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

enum FilterCellState {
    case selected
    case none
    var accessoryType: UITableViewCell.AccessoryType {
        switch self {
        case .selected:
            return .checkmark
        default:
            return .none
        }
    }
}

class FilterViewCell: UITableViewCell {


    
    @IBOutlet weak var lable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(item: Identifiable, state: FilterCellState){
        self.lable.text = item.name
        self.updateState(state: state)
        
    }
    
    func updateState(state: FilterCellState){
        self.accessoryType = state.accessoryType
    }
}
