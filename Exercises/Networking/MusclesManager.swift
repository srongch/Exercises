//
//  MusclesManager.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

class ListManager<T> {
    let group: DispatchGroup?
    var list: T?
    var dictionary: [Id: Item]?
    internal let network: ExerciseNetworkProtocol
    var handler: ((Swift.Result<Bool,Error>)-> Void)?
    
    var task: Promise<T>?{
        return nil
    }
    
    init(dispatchGroup: DispatchGroup? = nil, network:ExerciseNetworkProtocol, handler: ((Swift.Result<Bool,Error>)-> Void)? = nil){
        self.group = dispatchGroup
        self.network = network
        self.handler = handler
    }
    
    func load(){
        guard let task = self.task else{ return }
        self.group?.enter()
        PromiseLoader.load(task:task){[weak self] result in
            defer { self?.group?.leave() }
            self?.finishLoading(result: result)
            self?.finalTask()
            
        }
    }

    func finalTask() {
        
    }
    
    func finishLoading(result : Swift.Result<T,Error>){
        switch result {
        case .success(let list):
            self.list = list
            self.handler?(.success(true))
        case .failure(let error):
            self.handler?(.failure(error))
            break
        }
    }

}

class MusclesListManager: ListManager<MusclesList> {
   override var task: Promise<MusclesList>?{
        return self.network.getMusclesList()
    }
    
    override func finalTask() {
        self.dictionary = self.list?.toDictionary()
        super.finalTask()
    }
}

class EquipmentListManager: ListManager<EquimentList> {
    override var task: Promise<EquimentList>?{
         return self.network.getEquimentList()
     }
     
     override func finalTask() {
         self.dictionary = self.list?.toDictionary()
     }
}

class CategoryListManager: ListManager<CategoryList> {
    override var task: Promise<CategoryList>?{
         return self.network.getCategoryList()
     }
     
     override func finalTask() {
         self.dictionary = self.list?.toDictionary()
     }
}

class ExerciseListManager: ListManager<ExerciseList>{
    var filter : Filter?
    var search : String?
    
    func loadMore(filter : Filter?, search : String?){
        self.set(filter: filter, search: search)
        self.load()
    }
    
    func reload(filter : Filter?, search : String?){
        self.set(filter: filter, search: search)
        self.list = nil
        self.load()
    }
    
    override var task: Promise<ExerciseList>?{
         return self.network.getExerciseList(page: self.list?.nextPage ?? 1, name: self.search, filter: filter)
     }
    
    func set(filter : Filter?, search : String?){
        self.filter = filter
        self.search = search
    }
}
