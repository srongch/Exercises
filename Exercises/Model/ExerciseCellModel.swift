//
//  ExerciseCellModel.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

//model and protocol for displaying data on ViewController.
protocol ExerciceInforViewable {
    var id: Int {get}
    var name: String { get }
    var categoryName: String { get }
    var description: String? { get }
    var mainImage: String? { get }
    var allImage: [String]? { get }
    var equimentsList: String { get }
    var musclesList: String { get }
    var allEquiments: [String] { get }
    var allMusclesList: [String] { get }
}

extension ExerciceInforViewable{
    var cleanedDescription:String? {
        return self.description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}


struct ExerciseCellModel: ExerciceInforViewable {
    let id: Int
    let name: String
    let category: [Identifiable]?
    let image: [Identifiable]?
    let equiments: [Identifiable]?
    let muscles: [Identifiable]?
    let description: String?
    
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
    
    var allEquiments: [String] {
        return equiments?.compactMap({$0.name}) ?? []
    }
    
    var allMusclesList: [String] {
        return muscles?.compactMap({$0.name}) ?? []
    }
    
}
