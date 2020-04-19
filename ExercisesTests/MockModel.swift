//
//  MockModel.swift
//  ExercisesTests
//
//  Created by Dumbo on 20/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
@testable import Exercises

extension Exercise {
  static  var pageOne:[Exercise]{
        let exercise1 = Exercise.init(id: 1, name: "Beckenheben", categoryId: 1, equipmentIdList: [1,2], musclesIdList: [1,2], musclesSecondaryIdList: [3])
        let exercise2 = Exercise.init(id: 2, name: "Beinbeuger Liegend", categoryId: 2, equipmentIdList: [2], musclesIdList: [1], musclesSecondaryIdList: [1])
        return [exercise1, exercise2]
    }
    
   static var pageTwo:[Exercise]{
        let exercise1 = Exercise.init(id: 3, name: "Cable Woodchoppers", categoryId: 1, equipmentIdList: [1,2], musclesIdList: [1,2], musclesSecondaryIdList: [3])
        let exercise2 = Exercise.init(id: 4, name: "Crunches With Cable", categoryId: 2, equipmentIdList: [], musclesIdList: [], musclesSecondaryIdList: [])
        return [exercise1, exercise2]
    }
}

extension Image {
    static var imageList: [Int: [Image]]{
        let item1 = Image.init(id: 1, image: "https://wger.de/media/exercise-images/4/Crunches-1.png", isMain: true, exercise: 1)
        let item2 = Image.init(id: 2, image: "https://wger.de/media/exercise-images/91/Crunches-2.png", isMain: true, exercise: 1)
        let item3 = Image.init(id: 3, image: "https://wger.de/media/exercise-images/60/Hyperextensions-2.png", isMain: true, exercise: 1)
        return [1:[item1], 2:[item2], 3:[item3]]
    }
}


struct MockData {
    static func exerciseList(page: Int) -> ModelList<Exercise>{
        if page == 1 {
            return ModelList<Exercise>.init(count: 4, next: "https://wger.de/api/v2/exercise/?page=2&status=2", previous: nil, list: Exercise.pageOne )
        }else{
            return ModelList<Exercise>.init(count: 4, next: nil, previous: "https://wger.de/api/v2/exercise/?status=2", list:  Exercise.pageTwo )
        }
        
    }
    
    static func categoryList()-> CategoryList {
        let cat1 = Item.init(id: 1, name: "Abs")
        let cat2 = Item.init(id: 2, name: "Arms")
        let cat3 = Item.init(id: 3, name: "Chest")
        let cat4 = Item.init(id: 4, name: "Shoulders")
        let array = [cat1, cat2, cat3, cat4]
        return ModelList<Item>.init(count: 4, next: nil, previous: nil, list: array)
    }
    
    
    static func equimentListList()-> EquimentList {
        let equiment1 = Item.init(id: 1, name: "Barbell")
        let equiment2 = Item.init(id: 2, name: "Kettlebell")
        let equiment3 = Item.init(id: 3, name: "Pull-up bar")
        let equiment4 = Item.init(id: 4, name: "Swiss Ball")
        let array = [equiment1, equiment2, equiment3, equiment4]
        return ModelList<Item>.init(count: 4, next: nil, previous: nil, list: array)
    }
    
    static func muscleListList()-> MusclesList {
        let muscle1 = Item.init(id: 1, name: "Brachialis")
        let muscle2 = Item.init(id: 2, name: "Gluteus maximus")
        let muscle3 = Item.init(id: 3, name: "Pectoralis major")
        let muscle4 = Item.init(id: 4, name: "Quadriceps femoris")
        let array = [muscle1, muscle2, muscle3, muscle4]
        return ModelList<Item>.init(count: 4, next: nil, previous: nil, list: array)
    }
    
    static func muscleForId(id: Int)-> Item?{
        let muscles = MockData.muscleListList().toDictionary()
        return muscles[id]
    }
    
    static func imageListById(exerciseId: Int) -> ImageList{
        return ImageList.init(count: 3, next: nil, previous: nil, list: Image.imageList[exerciseId])
    }
    
    static func searchByTerm(term: String) -> ExerciseSearchList{
        let combine = Exercise.pageOne + Exercise.pageTwo
        let filter = combine.filter{
            $0.name.contains(term)
        }
        
        let exerciseSearch = filter.map{
            ExerciseSearch.init(data:SearchResult.init(id: $0.id, name: $0.name, category: MockData.muscleForId(id: $0.categoryId)?.name ?? "", imageThumnail: nil, image: nil) )
        }
        return ExerciseSearchList.init(list: exerciseSearch)
    }
}
