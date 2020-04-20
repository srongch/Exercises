//
//  MusclesManager.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

typealias PageIndex = Int

class ListManager<T:ModelListProtocol> {
    private var group: DispatchGroup?
    internal let network: ExerciseNetworkProtocol
    
    private(set) var list: T?
    var dictionary: [Id: Identifiable]?
    var handler: ((Swift.Result<Bool,Error>)-> Void)?
    
    var task: Promise<T>?{
        return nil
    }
    //where inital page is 1
    var pageIndex: Int{
        self.list?.currentPage ?? 1
    }
    private(set) var isAllLoaded: Bool = false
    
    init(dispatchGroup: DispatchGroup? = nil, network:ExerciseNetworkProtocol){
        self.group = dispatchGroup
        self.network = network
    }
    
    internal func reset() {
        self.list = nil
        self.isAllLoaded = false
    }
    
    func load(dispatchGroup: DispatchGroup? = nil){
        if let group = dispatchGroup {
            self.group = group
        }
        
        guard let task = self.task, !isAllLoaded else{ return }
        self.group?.enter()
        PromiseLoader.load(task:task){[weak self] result in
            defer { self?.group?.leave() }
            self?.finishLoading(result: result)
            self?.finalTask()
            
        }
    }

    internal func finalTask() {
        
    }
    
    private func finishLoading(result : Swift.Result<T,Error>){
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










