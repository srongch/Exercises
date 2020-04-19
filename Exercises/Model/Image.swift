//
//  Image.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

//model for image item
struct Image: Codable, Identifiable {
    let id: Int
    let image: String
    let isMain: Bool
    let exercise: Int

    var name: String {
        return image
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case isMain = "is_main"
        case image
        case exercise
    }
    
}
