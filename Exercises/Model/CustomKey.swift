//
//  CustomKey.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

// custom key class to use with NSCache
final class CustomKey<T: Hashable>: NSObject{
    let key: T
    init(key: T) {
        self.key = key
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CustomKey else {
            return false
        }
        return key == other.key
    }
    
    override var hash: Int {
        return key.hashValue
    }
}

