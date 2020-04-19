//
//  ExerciseInfoManager.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

class ExerciseInfoManager {
    private var id: Int?
    private(set) var data: ExerciseInfo?
    private let network: ExerciseNetworkProtocol
    private var group: DispatchGroup?
    
    init(networkManager: ExerciseNetworkProtocol) {
        self.network = networkManager
    }
    
    typealias Completion = ((Swift.Result<Bool,Error>)-> Void)
    
    func load(dispatchGroup: DispatchGroup? = nil, execiseId: Int, completion: Completion?){
        self.group = dispatchGroup
        self.group?.enter()
        self.id = execiseId
        let task = self.network.getExercisebyId(exerciseId: execiseId)
        PromiseLoader.load(task: task){[weak self] result in
            defer {self?.group?.leave()}
            switch result {
            case .success(let data):
                self?.data = data
                completion?(.success(true))
            case .failure(let error):
               completion?(.failure(error))
            }
        }
    }
}
