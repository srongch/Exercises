//
//  FilterViewCell.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit



class FilterViewCell: UITableViewCell {
    
    enum CellState {
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
    
    @IBOutlet weak var lable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(item: Identifiable, state: CellState){
        self.lable.text = item.name
        self.updateState(state: state)
        
    }
    
    func updateState(state: CellState){
        self.accessoryType = state.accessoryType
    }
}
