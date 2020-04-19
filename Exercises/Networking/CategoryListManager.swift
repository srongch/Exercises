//
//  CategoryListManager.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

final class CategoryListManager: ListManager<CategoryList> {
    override var task: Promise<CategoryList>?{
         return self.network.getCategoryList()
     }
     
     override func finalTask() {
         self.dictionary = self.list?.toDictionary()
     }
}
