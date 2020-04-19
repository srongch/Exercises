//
//  ExerciseNetworking.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

typealias ExerciseList = ModelList<Exercise>
typealias ImageList = ModelList<Image>

typealias CategoryList = ModelList<Item>
typealias MusclesList = ModelList<Item>
typealias EquimentList = ModelList<Item>
typealias SearchExerciseList = ExerciseSearchList

protocol ExerciseNetworkProtocol {
    
    //calling api/v2/exercise
    func getExerciseList(page: Int, filter: Filter? )-> Promise<ExerciseList>
    
    //calling exerciseinfo/<id>/
    func getExercisebyId(exerciseId: Int)-> Promise<ExerciseInfo>
    
    //calling api/v2/exercisecategory/
    func getCategoryList() -> Promise<CategoryList>
    
    //calling api/v2/muscle/
    func getMusclesList() -> Promise<MusclesList>
    
    //calling api/v2/equipment/
    func getEquimentList() -> Promise<EquimentList>
    
    //calling api/v2/exercisecategory/
    func getImageList(for exerciseId: Id) -> Promise<ImageList>
    
    //calling api/v2/exercisecategory/
    func searchExercise(for term: String) -> Promise<SearchExerciseList>
    
}

final class ExerciseNetwork : ExerciseNetworkProtocol{
    
    let provider: MoyaProvider<ExerciseApi>
    
    init( provider: MoyaProvider<ExerciseApi> ){
        self.provider = provider
    }
    
    func getExercisebyId(exerciseId: Int) -> Promise<ExerciseInfo> {
        return request(task: ExerciseApi.getExerciseById(id: exerciseId), value: ExerciseInfo.self)
    }
    
    func searchExercise(for term: String) -> Promise<SearchExerciseList> {
        return request(task: ExerciseApi.searchExercise(term: term), value: SearchExerciseList.self)
    }
    
    func getCategoryList() -> Promise<CategoryList> {
        return request(task: ExerciseApi.getCategory, value: CategoryList.self)
    }
    
    func getMusclesList() -> Promise<MusclesList> {
        return request(task: ExerciseApi.getMuscle, value: MusclesList.self)
    }
    
    func getEquimentList() -> Promise<EquimentList>{
        return request(task: ExerciseApi.getEquipment, value: EquimentList.self)
    }
    
    func getExerciseList(page: Int, filter: Filter? = nil)-> Promise<ExerciseList>{
        return request(task: ExerciseApi.getExercise(page: page, filter: filter ), value: ExerciseList.self)
    }
    
    func getImageList(for exerciseId: Id) -> Promise<ImageList>{
        return request(task: ExerciseApi.getImage(exerciseId: exerciseId), value: ImageList.self)
    }
    
    func request<T:Codable>(task: ExerciseApi, value: T.Type) -> Promise<T> {
        return Promise { seal in
            provider.request(task){ result in
                switch result {
                case .success(let response):
                    do {
                        let result = try response.map(value)
                        seal.fulfill(result)
                    } catch {
                        seal.reject(error)
                    }
                    
                case .failure(let error):
                    seal.reject(error)
                    
                }
            }
        }
    }
}
