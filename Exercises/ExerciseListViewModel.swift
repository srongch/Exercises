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
    
    enum StateCase {
        case all
        case search
    }
    private var listState: StateCase = .all
    
    private let network: ExerciseNetworkProtocol
    private var nextPage: Int?
    var filter: Filter?
    var search: String? {
        didSet {
            if oldValue != search {
//                print("Old value is \(oldValue) and new is \(search)")
                print("filter value: \(search)")
                self.reloadList()
            }else{
                print(" no search : \(search)")
            }
            
        }
    }
    
//    var categoryDictionary: [Id: Category] = [:]
//    var musclesDictionary: [Id: Muscle] = [:]
//    var equimentDictionary: [Id: Equipment] = [:]
//    var exerciseList: [Exercise] = []
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
    let exerciseListManager: ExerciseListManager
    lazy var searchManager: SearchManager = {
        let search = SearchManager.init(network: self.network)
        return search
    }()
    
    var allLoaded: Bool {
        switch self.listState {
        case .all:
             return self.exerciseListManager.isAllLoaded
        default:
            return self.searchManager.isAllLoaded
        }
    }
    
    init(network: ExerciseNetworkProtocol, initialPage: Int? = 1) {
        self.network = network
        self.nextPage = initialPage
        self.musclesListManager = MusclesListManager.init(dispatchGroup: group, network: network)
        self.categoryListManager = CategoryListManager.init(dispatchGroup: group, network: network)
        self.equipmentListManager = EquipmentListManager.init(dispatchGroup: group, network: network)
        self.exerciseListManager = ExerciseListManager.init(dispatchGroup: nil, network: network)
        self.exerciseListManager.handler = {[weak self] result in
            self?.isLoading = false
            print(self?.exerciseListManager.list)
            self?.completionHandler?(result)
            
        }
    }
    
    func reloadList(){
        if let search = self.search {
            self.listState = .search
           self.searchManager.handler = {[weak self] result in
               self?.isLoading = false
               self?.completionHandler?(result)
           }
            self.searchManager.search(term: search)
        }else{
            self.listState = .all
            if self.numberOfItem() > 0 {
                self.completionHandler?(.success(true))
            }else{
                self.exerciseListManager.reload(filter: self.filter)
            }
           
        }
        
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
        switch self.listState {
        case .all:
            return self.exerciseListManager.list?.numberOfItem() ?? 0
        default:
            return self.searchManager.list?.numberOfItem() ?? 0
        }
        
    }
    

    
    func itemAtIdex(index: Int)-> ExerciceInforViewable? {
        switch self.listState {
        case .all:
            guard let exercise = self.exerciseListManager.list?.itemAtIdex(index: index) else {return nil}
            let category = categoryListManager.itemForIds([exercise.categoryId])
            let equipment = equipmentListManager.itemForIds(exercise.equipmentIdList)
            let muslces = musclesListManager.itemForIds(exercise.musclesIdList)
            let image = self.imageList.object(forKey: CustomKey.init(key: exercise.id))
            
            let exerciseModel = ExerciseCellModel.init(id: exercise.id, name: exercise.name, category: category, image: image?.list, equiments: equipment, muscles: muslces)
            print(exerciseModel)
            return exerciseModel
        default:
            guard let search = self.searchManager.list?.itemAtIdex(index: index) else {return nil}
           
            return search.toExerciceInforViewable
        }

        
    }
    
    func loadMore() {
        guard !self.isLoading, !self.allLoaded else {
            return
        }
         self.isLoading = true
        self.exerciseListManager.loadMore(filter: self.filter)
    }
    
    func fetchExercise(){
        guard !self.isLoading else {
            return
        }
        self.isLoading = true
        self.exerciseListManager.reload(filter: self.filter)
    }
    
    func fetchImageListAsync(exerciseId: ExerciseId, completion: ((String?) -> Void)? = nil ){
        
        if let imageList = self.loadImageForExercise(id: exerciseId) {
            completion?(imageList.firstItem)
            return
        }
        
        let imageManager = ExerciseImageListManager.init(dispatchGroup: nil, network: network)
        imageManager.handler = { [ weak self] _ in
            if let imageList =  List.init(list: imageManager.list?.list, id: exerciseId) {
                print("download complete")
                self?.imageList.setObject(imageList, forKey: CustomKey(key: exerciseId))
                completion?(imageList.firstItem)
            }else{
                print("download nil")
                completion?(nil)
            }
        }
        imageManager.loadImageFor(id: exerciseId)
        
        
//
//
//
//        firstly {
//            network.getImageList(for: exerciseId)
//        }.done {[weak self] imageList in
//           print("finish image ")
//            let imageList = List.init(list: imageList.list, id: <#Int#>)
//            self?.imageList.setObject(imageList, forKey: CustomKey(key: exerciseId))
//          // print("countLimit \(self?.imageList.countLimit) ")
//            completion?(imageList)
//
//        }.catch { [weak self] error in
//            print("\(error.localizedDescription)")
////            guard let strongSelf = self else { return }
////            strongSelf.delegate?.error(error: error.localizedDescription)
//        }
    }
    
    func loadImageForExercise(id exerciseId: ExerciseId) -> List<Image>?{
        print(imageList.description)
        let object = imageList.object(forKey: CustomKey(key: exerciseId))
        print(object == nil ? "no" : "yes")
        return object
    }
}
