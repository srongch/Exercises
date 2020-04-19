//
//  ExerciseInfo.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

//Model for api/v2/exerciseinfo/<id>/
struct ExerciseInfo: Codable {
    let name: String
    let category: Item
    let description: String?
    let muscles: [Item]?
    let musclesSecondary: [Item]?
    let equipment: [Item]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case category
        case description
        case muscles
        case musclesSecondary = "muscles_secondary"
        case equipment
    }
    
    
}

extension ExerciseInfo {
    
    var allMuscle:[Item]? {
        if let muscles = self.muscles, let subMuscles = self.musclesSecondary {
            return muscles + subMuscles
        }else{
            return self.muscles
        }
    }
    func toExerciceInforViewable(with imageList: [Identifiable]) -> ExerciceInforViewable {
        let exercise = ExerciseCellModel.init(id: 0, name: name, category: [category], image: imageList, equiments: equipment, muscles:allMuscle , description: description)
        return exercise
    }
}
