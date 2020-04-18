//
//  List.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

class List<T> {
    let id: Int
    let list: [T]
    
    init?(list: [T]?, id: Int) {
        guard let list = list else {return nil}
        self.id = id
        self.list = list
    }
}

extension List where T:Identifiable {
    var firstItem: String? {
        guard let first = self.list.first else {return nil}
        return first.name
    }
}
