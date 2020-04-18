//
//  Filter.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

enum Filter {
    case muscles (String)
    
    var value: (key: String, value: String) {
        switch self {
        case .muscles (let value):
            return ("muscles", value)
        }
    }
}
