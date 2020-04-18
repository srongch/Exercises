//
//  ExerciseCellModel.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

protocol ExerciceInforViewable {
    var id: Int {get}
    var name: String { get }
    var categoryName: String { get }
    var mainImage: String? { get }
    var allImage: [String]? { get }
    var equimentsList: String { get }
    var musclesList: String { get }
}

struct ExerciseCellModel: ExerciceInforViewable {
    let id: Int
    let name: String
    let category: [Identifiable]?
    let image: [Identifiable]?
    let equiments: [Identifiable]?
    let muscles: [Identifiable]?
    
    var allImage: [String]? {
        guard let first = self.image else {return nil}
        return first.map{$0.name}
    }
    
    var categoryName: String {
        guard let category = self.category, category.count > 0 else {return ""}
        return category.map({$0.name}).joined(separator: ", ")
    }
    
    var mainImage: String? {
        guard let image = self.image else {return nil}
        guard let first = image.first else {return ""}
        return first.name
    }
    
    var equimentsList: String{
        guard let equiments = self.equiments, equiments.count > 0 else {return ""}
        return "🏋️" + equiments.map({$0.name}).joined(separator: ", ")
    }
    
    var musclesList: String {
        guard let muscles = self.muscles, muscles.count > 0 else {return ""}
        return "💪" + muscles.map({$0.name}).joined(separator: ", ")
    }
}
