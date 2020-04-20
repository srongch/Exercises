//
//  ExerciseListManager.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

final class ExerciseListManager: ListManager<ExerciseList>{
    private(set) var filter : Filter?
    
    func loadMore(filter : Filter?){
        self.set(filter: filter)
        self.load()
    }
    
    func reload(filter : Filter?){
        self.set(filter: filter)
        self.reset()
        self.load()
    }
    
    override var task: Promise<ExerciseList>?{
         return self.network.getExerciseList(page: self.list?.nextPage ?? 1, filter: filter)
     }
    
    func set(filter : Filter?){
        self.filter = filter
    }
}
