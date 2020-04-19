//
//  FakeNetwork.swift
//  ExercisesTests
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
@testable import Exercises
import PromiseKit
import Moya

class FakeNetwork: ExerciseNetworkProtocol{
    
   
    func getExerciseList(page: Int, filter: Filter?) -> Promise<ExerciseList> {
        return Promise { seal in
            seal.fulfill(MockData.exerciseList(page: page))
        }
    }
    
    func getExercisebyId(exerciseId: Int) -> Promise<ExerciseInfo> {
        <#code#>
    }
    
    func getCategoryList() -> Promise<CategoryList> {
        return Promise { seal in
            seal.fulfill(MockData.categoryList())
        }
    }
    
    func getMusclesList() -> Promise<MusclesList> {
        return Promise { seal in
            seal.fulfill(MockData.muscleListList())
        }
    }
    
    func getEquimentList() -> Promise<EquimentList> {
        return Promise { seal in
            seal.fulfill(MockData.equimentListList())
        }
    }
    
    func getImageList(for exerciseId: Id) -> Promise<ImageList> {
        return Promise { seal in
            seal.fulfill(MockData.imageListById(exerciseId: exerciseId))
        }
    }
    
    func searchExercise(for term: String) -> Promise<SearchExerciseList> {
        return Promise { seal in
            seal.fulfill(MockData.searchByTerm(term: term))
        }
    }
    
    
}

