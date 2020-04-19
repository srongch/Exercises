//
//  ExerciseList.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

protocol ModelListProtocol {
    associatedtype ItemList
    var count: Int {get set }
    var next: String? {get set }
    var previous: String? {get set }
    var list: [ItemList]? {get set }
    
}

typealias Id = Int

extension ModelListProtocol {
 
    var nextPage: Int?{
        guard let next = try? self.next?.asURL().valueOf("page") else { return nil}
        return Int(next)
    }
    
    var previousPage: Int? {
        guard let next = try? self.previous?.asURL().valueOf("page") else { return nil}
        return Int(next)
    }
    
    mutating func merge(newObject : Self){
        guard (self.list != nil) else {return }
        self.count = newObject.count
        self.next = newObject.next
        self.previous = newObject.previous
        self.list! += newObject.list ?? []
    }
    
    // where page start from 1
    var currentPage: Int {
        let page = (nextPage, previousPage)
        switch page {
        case let (nextPage?, previousPage?) where nextPage > 0  || previousPage > 0:
            return nextPage - 1
        case let (nextPage?, nil) where nextPage > 0:
            return nextPage - 1
        case let (nil, previousPage?) where previousPage > 0:
            return previousPage + 1
        default:
            return 1
        }
    }
    
    
    func numberOfItem()-> Int {
        return self.list?.count ?? 0
    }
    
    func itemAtIdex(index: Int)-> ItemList? {
        return self.list?[safeIndex: index]
    }
    
    
}
extension ModelListProtocol where ItemList: Identifiable {
    func toDictionary()-> [Id: ItemList] {
      return list?.reduce(into: [Id: ItemList]()) {
        $0[$1.id] = $1
        } ?? [:]
    }
}


// Model for api/v2/exercise/  |  api/v2/exerciseimage/ |  api/v2/equipment/  |  api/v2/muscle/   | api/v2/exercisecategory/
struct ModelList<T: Codable>: Codable, ModelListProtocol {
    typealias ItemList = T
    var count: Int
    var next: String?
    var previous: String?
    var list: [T]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
       case list = "results"
    }
    
}

