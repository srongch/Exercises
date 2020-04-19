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
    
    var selectedBodyPart: Identifiable?{
        didSet {
            if oldValue?.id != selectedBodyPart?.id{
                self.fetchExercise()
            }
        }
    }
    
    private var filter: Filter? {
        guard let filter = selectedBodyPart, filter.id >= 0 else {return nil}
        return .category(filter.id)
    }
    var search: String? {
        didSet {
            if oldValue != search {
                self.reloadList()
            }else{
                print(" no need to search")
            }
        }
    }
    
    private var imageList = NSCache<CustomKey<Int>, List<Image>>()
    
    typealias Handler = (Swift.Result<Bool, Error>) -> Void
    var completionHandler: Handler?
    
    private var isLoading: Bool = false

    private let group = DispatchGroup()
    private let mainQueue = DispatchQueue.main
    
    private let musclesListManager: MusclesListManager
    private let categoryListManager: CategoryListManager
    private let equipmentListManager: EquipmentListManager
    private let exerciseListManager: ExerciseListManager
    private lazy var searchManager: SearchManager = {
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
    
    var detailComponent:(exerciseInfoManager: ExerciseInfoManager, exerciseImageListManager: ExerciseImageListManager){
        return ((ExerciseInfoManager.init(networkManager: network),  ExerciseImageListManager.init( network: network)))
    }
    var filterComponents:(filterList: [Identifiable], preSelectedItem: Identifiable?)?{
        guard var filterList = self.categoryListManager.list?.list else {
            return nil
        }
        let allFilter = Item.createExtraIndexItem(name: "All body parts")
        filterList.insert(allFilter, at: 0)
        return (filterList, self.selectedBodyPart)
    }
    
    init(network: ExerciseNetworkProtocol) {
        self.network = network
        self.musclesListManager = MusclesListManager.init(dispatchGroup: group, network: network)
        self.categoryListManager = CategoryListManager.init(dispatchGroup: group, network: network)
        self.equipmentListManager = EquipmentListManager.init(dispatchGroup: group, network: network)
        self.exerciseListManager = ExerciseListManager.init(dispatchGroup: nil, network: network)
        self.exerciseListManager.handler = {[weak self] result in
             self?.isLoading = false
            self?.completionHandler?(result)
        }
    }
    
    private func reloadList(){
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
                self.exerciseListManager.reload(filter: filter)
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
    
    var shouldShowReloadCell: Bool{
        return self.search == nil ? true : false
    }
    
    var shouldShowSearchEmtpyCell: Bool{
        return (self.numberOfItem() == 0 && self.search != nil) ? true : false
    }
    
    var shouldShowShorterHeight: Bool{
        return self.listState == .all ? false : true
    }
    
    func itemAtIdex(index: Int)-> ExerciceInforViewable? {
        switch self.listState {
        case .all:
            guard let exercise = self.exerciseListManager.list?.itemAtIdex(index: index) else {return nil}
            let category = categoryListManager.itemForIds([exercise.categoryId])
            let equipment = equipmentListManager.itemForIds(exercise.equipmentIdList)
            let muslces = musclesListManager.itemForIds(exercise.musclesIdList) + musclesListManager.itemForIds(exercise.musclesSecondaryIdList)
            let image = self.imageList.object(forKey: CustomKey.init(key: exercise.id))
            
            let exerciseModel = ExerciseCellModel.init(id: exercise.id, name: exercise.name, category: category, image: image?.list, equiments: equipment, muscles: muslces, description: nil)
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
        self.exerciseListManager.loadMore(filter:filter )
    }
    
    private func fetchExercise(){
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
    }
    
    func loadImageForExercise(id exerciseId: ExerciseId) -> List<Image>?{
        print(imageList.description)
        let object = imageList.object(forKey: CustomKey(key: exerciseId))
        return object
    }
}
