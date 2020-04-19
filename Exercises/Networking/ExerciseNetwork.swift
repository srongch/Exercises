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
    
    //Get all car information from carList.json
    func getExerciseList(page: Int, filter: Filter? )-> Promise<ExerciseList>
    func getExercisebyId(exerciseId: Int)-> Promise<ExerciseInfo>
    func getCategoryList() -> Promise<CategoryList>
    func getMusclesList() -> Promise<MusclesList>
    func getEquimentList() -> Promise<EquimentList>
    func getImageList(for exerciseId: Id) -> Promise<ImageList>
    func searchExercise(for term: String) -> Promise<SearchExerciseList>
    
    
//    //Get car list from API
//    func getCarList(for bounds: MapBound) -> Promise<[Model]>
//
//    //Get address of each coodinate from Google Map
//    func getAddress(location :(latitude : Double,longtitude : Double))-> Promise<Address>
}

final class ExerciseNetwork : ExerciseNetworkProtocol{
    func getExercisebyId(exerciseId: Int) -> Promise<ExerciseInfo> {
        return request(task: ExerciseApi.getExerciseById(id: exerciseId), value: ExerciseInfo.self)
    }
    
    func searchExercise(for term: String) -> Promise<SearchExerciseList> {
        return request(task: ExerciseApi.searchExercise(term: term), value: SearchExerciseList.self)
    }
    
    
    
    let provider: MoyaProvider<ExerciseApi>
    
    init( provider: MoyaProvider<ExerciseApi> ){
        self.provider = provider
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
                     //   let value: Data // received from a network request, for example
                        let json = try response.mapJSON()
                         print(json)
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
    
//    func
    
    
//    func getExerciseList()-> Promise<ExerciseList> {
//        return Promise { seal in
//            provider.request(.getExercise(param: 0)){ result in
//                switch result {
//                case .success(let response):
//                    do {
//                        let result = try response.map(ExerciseList.self)
//                        //  print(result)
//                        seal.fulfill(result)
//                    } catch {
//                        seal.reject(error)
//                    }
//
//                case .failure(let error):
//                    seal.reject(error)
//
//                }
//            }
//        }
//    }

    
    
//    func get
    
//    func getAddress(location: (latitude : Double,longtitude : Double)) -> Promise<Address> {
//        return Promise { seal in
//            provider.request(.getAddress(latitude: location.latitude, longtitute: location.longtitude)) { result in
//                switch result {
//                case .success(let response):
//
//                    do {
//                        let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as! [String: Any]
//                        if let results = jsonResult["results"] as? [Any],
////                            let isIndexValid = results.indices.contains(0),
//                            results.count > 0,
//                            let first = results[0] as? [String : Any],
//                            let address = first["formatted_address"] as? String {
//                          //  print(address)
//                            seal.fulfill(Address(address: address,longtitude: location.1,latitude: location.0))
//                        }
//                        else {
//                            // the value of someOptional is not set (or nil).
//                            seal.fulfill(Address(address: "Address not found",longtitude: location.1,latitude: location.0))
//                        }
//
//                    } catch {
//                        seal.reject(error)
//                    }
//
//                case .failure(let error):
//                    seal.reject(error)
//
//                }
//            }
//        }
//    }

    
//    func getCarList(for bounds: MapBound) -> Promise<[Model]> {
//        return Promise { seal in
//            provider.request(.getList(latitude1: bounds.latitude1, longtitute1: bounds.longtitute1, latitude2: bounds.latitude2, longtitute2: bounds.longtitute2)) { result in
//                switch result {
//                case .success(let response):
//                    do {
//                        let result = try response.map(CarListResult<Model>.self).poiList
//                      //  print(result)
//                        seal.fulfill(result)
//                    } catch {
//                       seal.reject(error)
//                    }
//
//                case .failure(let error):
//                    seal.reject(error)
//
//                }
//            }
//        }
//    }
//
//    func getCarInformation() -> Promise<[Car]> {
//        return Promise { seal in
//            if let pathURL = Bundle.main.url(forResource: "carlist", withExtension: "json") {
//
//                    let data = try Data(contentsOf: pathURL, options: .mappedIfSafe)
//                    let decoder = JSONDecoder()
//
//                    do {
//                        let decoded = try decoder.decode([Car].self, from: data)
////                        print(decoded)
//                        seal.fulfill(decoded)
//                    } catch {
//                        print("Failed to decode JSON")
//                        seal.reject(error)
//                    }
//            }
//
//        }
//    }
//
}
