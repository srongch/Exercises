//
//  ExerciseListViewModel.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

    typealias ExerciseId = Int

class ExerciseListViewModel {
    
    private let network: ExerciseNetworkProtocol
    private var nextPage: Int?
    var filter: Muscle?
    var search: String?
    
    var categoryDictionary: [Id: Category] = [:]
    var musclesDictionary: [Id: Muscle] = [:]
    var equimentDictionary: [Id: Equipment] = [:]
    var exerciseList: [Exercise] = []
//    var imageList: [ExerciseId: [Image]] = [:]
    private var imageList = NSCache<CustomKey<Int>, List<Image>>()
    
    typealias Handler = (Swift.Result<Bool, Error>) -> Void
    var completionHandler: Handler?
    
    var isLoading: Bool = false

    let group = DispatchGroup()
    let mainQueue = DispatchQueue.main
    
    let musclesListManager: MusclesListManager
    let categoryListManager: CategoryListManager
    let equipmentListManager: EquipmentListManager
    
    init(network: ExerciseNetworkProtocol, initialPage: Int? = 1) {
        self.network = network
        self.nextPage = initialPage
        self.musclesListManager = MusclesListManager.init(dispatchGroup: group, network: network, handler: nil)
        self.categoryListManager = CategoryListManager.init(dispatchGroup: group, network: network, handler: nil)
        self.equipmentListManager = EquipmentListManager.init(dispatchGroup: group, network: network, handler: nil)
        
    }
    
    func initialFetch(completionHandler: Handler?){
        self.isLoading = true
        self.completionHandler = completionHandler
        self.musclesListManager.load()
        self.categoryListManager.load()
        self.equipmentListManager.load()
                group.notify(queue: .main) {
                    print("done")
                    self.isLoading = false
                    self.fetchExercise()
                }
    }
    
    func numberOfItem()-> Int {
        return self.exerciseList.count
    }
    
    func itemAtIdex(index: Int)-> Exercise {
        return self.exerciseList[index]
    }
    
    func fetchExercise(){
        guard let page = self.nextPage, !self.isLoading else {
            
            return
        }
      print("loading page \(page)")
        self.isLoading = true
        firstly {
            network.getExerciseList(page: page, name: self.search, filter: nil)
        }.done { [weak self] exerciseList  in
            self?.exerciseList += exerciseList.list
            self?.nextPage = exerciseList.nextPage
       //     print(self?.nextPage)
            self?.completionHandler?(.success(true))
            self?.isLoading = false
            print(exerciseList)
//            exerciseList.list.forEach{
////                self?.fetchImageListAsync(exerciseId: $0.id)
//            }
        //    print(self?.exerciseList)
//            self.nextPage = models.nextPage
//            guard (models.nextPage != nil) else{
//                print("all data loaded")
//                self.isFinished = true
//                self.onCompletion?()
//                return
//            }
//            self.onCompletion?()
        }.catch {[weak self] error in
            print(error.localizedDescription)
            fatalError("error")
            self?.isLoading = false
            //                guard let strongSelf = self else { return }
            //                strongSelf.delegate?.error(error: error.localizedDescription)
        }
    }
    
    func fetchImageListAsync(exerciseId: ExerciseId, completion: ((List<Image>?) -> Void)? = nil ){
        
        if let imageList = self.loadImageForExercise(id: exerciseId) {
            completion?(imageList)
            return
        }
        
        firstly {
            network.getImageList(for: exerciseId)
        }.done {[weak self] imageList in
           print("finish image ")
            let imageList = List.init(list: imageList.list)
            self?.imageList.setObject(imageList, forKey: CustomKey(key: exerciseId))
          // print("countLimit \(self?.imageList.countLimit) ")
            completion?(imageList)
           
        }.catch { [weak self] error in
            print("\(error.localizedDescription)")
//            guard let strongSelf = self else { return }
//            strongSelf.delegate?.error(error: error.localizedDescription)
        }
    }
    
    func loadImageForExercise(id exerciseId: ExerciseId) -> List<Image>?{
        print(imageList.description)
        let object = imageList.object(forKey: CustomKey(key: exerciseId))
        print(object == nil ? "no" : "yes")
        return object
    }
}
