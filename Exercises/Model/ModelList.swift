//
//  ExerciseList.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation


struct ModelList<T: Codable>: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let list: [T]
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
       case list = "results"
    }
    
}

typealias Id = Int

extension ModelList {
    var nextPage: Int?{
        guard let next = try? self.next?.asURL().valueOf("page") else { return nil}
        return Int(next)
    }
    
    var previousPage: Int? {
        guard let next = try? self.previous?.asURL().valueOf("page") else { return nil}
        return Int(next)
    }
}
extension ModelList where T: Identifiable {
    func toDictionary()-> [Id: T] {
      return list.reduce(into: [Id: T]()) {
        $0[$1.id] = $1
      }
    }
    
}

extension ModelList where T: Mappable {
    func toDictionArray()-> [Id: [T]] {
        guard self.list.count > 0,
            let item = self.list.first else {return [:]}
        return [item.mapKey: list]
    }
    
}
