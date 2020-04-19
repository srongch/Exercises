//
//  Filter.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation


enum Filter {
    case category (Int)
    
    var value: (key: String, value: Int) {
        switch self {
        case .category (let value):
            return ("category", value)
        }
    }
}
