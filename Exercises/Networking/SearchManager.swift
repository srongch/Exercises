//
//  SearchManager.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

final class SearchManager: ListManager<SearchExerciseList> {
    var term : String!
    func search(term: String){
        self.term = term.appending(term.isEmpty ? " " : "")
        self.reset()
        self.load()
    }
    
    override var task: Promise<SearchExerciseList>?{
        return self.network.searchExercise(for: self.term)
     }
}
