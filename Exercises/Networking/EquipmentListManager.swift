//
//  EquipmentListManager.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

final class EquipmentListManager: ListManager<EquimentList> {
    override var task: Promise<EquimentList>?{
         return self.network.getEquimentList()
     }
     
     override func finalTask() {
         self.dictionary = self.list?.toDictionary()
     }
}
