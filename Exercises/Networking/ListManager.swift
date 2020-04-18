//
//  MusclesManager.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

class ListManager<T:ModelListProtocol> {
    let group: DispatchGroup?
    var list: T?
    var dictionary: [Id: Identifiable]?
    internal let network: ExerciseNetworkProtocol
    var handler: ((Swift.Result<Bool,Error>)-> Void)?
    
    var task: Promise<T>?{
        return nil
    }
    
    var isAllLoaded: Bool = false
    
    init(dispatchGroup: DispatchGroup? = nil, network:ExerciseNetworkProtocol){
        self.group = dispatchGroup
        self.network = network
    }
    
    func load(){
        guard let task = self.task, !isAllLoaded else{ return }
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
            if (self.list != nil) {
                 self.list!.merge(newObject: list)
            }else{
                self.list = list
            }
            
            self.isAllLoaded =  (list.next != nil) ? false : true
            self.handler?(.success(true))
        case .failure(let error):
            self.handler?(.failure(error))
            break
        }
    }
    
    func itemForIds(_ ids: [Int])-> [Identifiable]{
        return ids.compactMap{self.dictionary?[$0]}
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
    
    func loadMore(filter : Filter?){
        self.set(filter: filter)
        self.load()
    }
    
    func search(search: String){
        
    }
    
    func reload(filter : Filter?){
        self.set(filter: filter)
        self.list = nil
        self.isAllLoaded = false
        self.load()
    }
    
    override var task: Promise<ExerciseList>?{
         return self.network.getExerciseList(page: self.list?.nextPage ?? 1, filter: filter)
     }
    
    func set(filter : Filter?){
        self.filter = filter
    }
}

class ExerciseImageListManager: ListManager<ImageList>{
    
    var exerciseId : Int = 0

    func loadImageFor(id exerciseId: ExerciseId){
        self.exerciseId = exerciseId
         self.load()
    }

    override var task: Promise<ImageList>?{
        return self.network.getImageList(for: exerciseId)
     }
}
