//
//  ExerciseImageListManager.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

final class ExerciseImageListManager: ListManager<ImageList>{
    
    var exerciseId : Int = 0

    func loadImageFor(id exerciseId: ExerciseId, dispatchGroup: DispatchGroup? = nil){
        self.exerciseId = exerciseId
        self.load(dispatchGroup: dispatchGroup)
    }
    
    override var task: Promise<ImageList>?{
        return self.network.getImageList(for: exerciseId)
     }
}
