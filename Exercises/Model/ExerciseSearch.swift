//
//  Search.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

struct ExerciseSearchList: Codable {
    var list: [ExerciseSearch]
    
    enum CodingKeys: String, CodingKey {
        case list = "suggestions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.list = try values.decode([ExerciseSearch].self, forKey: .list)
    }
}

extension ExerciseSearchList: ModelListProtocol{

    var count: Int {
        get {
            return list.count
        }
        set { }
    }
    
    var next: String? {
        get {
            return nil
        }
        set { }
    }
    
    var previous: String? {
        get {
            return nil
        }
        set { }
    }
    
    typealias ItemList = ExerciseSearch
    
}


struct ExerciseSearch: Codable {
    struct SearchResult: Codable {
        let id: Int
        let name: String
        let category: String
        let imageThumnail: String?
        let image: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case category
            case image
            case imageThumnail = "image_thumbnail"
        }
        
    }
    
    var imageArray: [Item]{
        guard let image = self.data.image else {
            return []
            
        }
        return [Item(id:data.id, name: image)]
    }

    let data: SearchResult
    
    var toExerciceInforViewable: ExerciceInforViewable{
        let exerciseModel = ExerciseCellModel.init(id: data.id, name: data.name, category: [Item(id:data.id, name: data.category)], image: imageArray , equiments: nil, muscles: nil)
        return exerciseModel
    }
    
}
