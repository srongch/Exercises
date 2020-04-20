//
//  FilterListViewModel.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

class FilterListViewModel{
    private let filterList: [Identifiable]
    private var preSelectedItem: Identifiable?
    
    init(filterList: [Identifiable], preSelectedItem: Identifiable? = nil) {
        self.filterList = filterList
        print(self.filterList.count)
        self.preSelectedItem = preSelectedItem
    }
    
    
    var numberOfRow: Int{
        return self.filterList.count
    }
    
    func itemAtIndex(indexPath: IndexPath) -> Identifiable? {
        return self.filterList[indexPath.row]
    }
    
    func stateForItem(item: Identifiable) -> FilterViewCell.CellState{
        return preSelectedItem?.id == item.id ? .selected : .none
    }
    
}
