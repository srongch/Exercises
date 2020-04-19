//
//  MusclesListManager.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

final class MusclesListManager: ListManager<MusclesList> {
   override var task: Promise<MusclesList>?{
        return self.network.getMusclesList()
    }
    
    override func finalTask() {
        self.dictionary = self.list?.toDictionary()
        super.finalTask()
    }
}
