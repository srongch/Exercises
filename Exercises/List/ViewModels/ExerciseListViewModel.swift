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

final class ExerciseListViewModel {
    
    enum StateCase {
        case all
        case search
    }
    
    // determine the state of current view
    private(set) var listState: StateCase = .all
    
    private let network: ExerciseNetworkProtocol
    
    // user for Filter
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
    
    // search text
    var search: String? {
        didSet {
            if oldValue != search {
                self.reloadList()
            }else{
                print(" no need to search")
            }
        }
    }
    
    // cache all image list by ExceriseID
    private var imageList = NSCache<CustomKey<Int>, List<Image>>()
    
    typealias Handler = (Swift.Result<Bool, Error>) -> Void
    var completionHandler: Handler?
    
    private(set) var isLoading: Bool = false

    private let group = DispatchGroup()
    private let mainQueue = DispatchQueue.main
    
    let musclesListManager: MusclesListManager
    let categoryListManager: CategoryListManager
    let equipmentListManager: EquipmentListManager
    let exerciseListManager: ExerciseListManager
    private(set) lazy var searchManager: SearchManager = {
        let search = SearchManager.init(network: self.network)
        return search
    }()
    
    // determine if no more data to load
    var allLoaded: Bool {
        switch self.listState {
        case .all:
             return self.exerciseListManager.isAllLoaded
        default:
            return self.searchManager.isAllLoaded
        }
    }
    
    // components to detail view required by ExerciseInfoViewModel
    var detailComponent:(exerciseInfoManager: ExerciseInfoManager, exerciseImageListManager: ExerciseImageListManager){
        return ((ExerciseInfoManager.init(networkManager: network),  ExerciseImageListManager.init( network: network)))
    }
    
    // components to filter view required by FilterListViewModel
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
    
    // refresh list
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
            if self.numberOfItem > 0 {
                self.completionHandler?(.success(true))
            }else{
                self.exerciseListManager.reload(filter: filter)
            }
        }
    }
    
    // start loading all the require compenents before loading exercise list.
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
    
    // number of exercise in Seach or All list
    var numberOfItem: Int {
        switch self.listState {
        case .all:
            return self.exerciseListManager.list?.numberOfItem() ?? 0
        default:
            return self.searchManager.list?.numberOfItem() ?? 0
        }
        
    }
    
    // for showing loading view cell when list is empty
    var shouldShowReloadCell: Bool{
        return self.search == nil ? true : false
    }
    
    // for showing empty cell when list is empty while searching.
    var shouldShowSearchEmtpyCell: Bool{
        return (self.numberOfItem == 0 && self.search != nil) ? true : false
    }
    
    // get item viewable for CollectionViewCell.
    func itemAtIdex(index: Int)-> ExerciceInforViewable? {
        switch self.listState {
        case .all:
            guard let exercise = self.exerciseListManager.list?.itemAtIdex(index: index) else {return nil}
            let category = categoryListManager.itemForIds([exercise.categoryId])
            let equipment = equipmentListManager.itemForIds(exercise.equipmentIdList)
            let muslces = musclesListManager.itemForIds(exercise.musclesIdList) + musclesListManager.itemForIds(exercise.musclesSecondaryIdList)
            let image = self.imageList.object(forKey: CustomKey.init(key: exercise.id))
            
            let exerciseModel = ExerciseCellModel.init(id: exercise.id, name: exercise.name, category: category, image: image?.list, equiments: equipment, muscles: muslces, description: exercise.description)
            return exerciseModel
        default:
            guard let search = self.searchManager.list?.itemAtIdex(index: index) else {return nil}
           
            return search.toExerciceInforViewable
        }

    }
    
    // loading next page only if no current loading task
    func loadMore() {
        guard !self.isLoading, !self.allLoaded else {
            return
        }
        self.isLoading = true
        self.exerciseListManager.loadMore(filter:filter )
    }
    
    // load list from the beginning
    private func fetchExercise(){
        self.isLoading = true
        self.exerciseListManager.reload(filter: self.filter)
    }
    
    //load image list Async and save to cache there after
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
    
    //get image list by exercise.
    func loadImageForExercise(id exerciseId: ExerciseId) -> List<Image>?{
        print(imageList.description)
        let object = imageList.object(forKey: CustomKey(key: exerciseId))
        return object
    }
}
