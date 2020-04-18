//
//  Item.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: Int { get }
    var name: String {get}
}

struct Item: Codable, Identifiable {
    let id: Int
    let name: String
}

typealias Category = Item
typealias Equipment = Item
typealias Muscle = Item



