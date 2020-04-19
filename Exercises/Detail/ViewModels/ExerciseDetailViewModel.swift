//
//  ExerciseDetailViewModel.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

class ExerciseDetailViewModel {
    private let exerciseId: Int
    private let exerciseInforManger: ExerciseInfoManager
    private let imageListManager: ExerciseImageListManager
    
    private let group = DispatchGroup()
    private let mainQueue = DispatchQueue.main
    
    private var exerciseInfor: ExerciceInforViewable?
    
    typealias Handler = (Swift.Result<Bool, Error>) -> Void
    var completionHandler: Handler?
    
    init(exerciseId: Int, exerciseInforManger: ExerciseInfoManager, imageListManager: ExerciseImageListManager){
        self.exerciseId = exerciseId
        self.exerciseInforManger = exerciseInforManger
        self.imageListManager = imageListManager
    }
    
    func loadData() {
//        self.completionHandler?.c
        self.exerciseInforManger.load(dispatchGroup: group, execiseId: exerciseId, completion: nil)
        self.imageListManager.loadImageFor(id: exerciseId, dispatchGroup: group)
        group.notify(queue: .main) {
            guard let data = self.exerciseInforManger.data,
                let images = self.imageListManager.list?.list else {
                    self.completionHandler?(.failure(AppCustomError.failed))
                    return
            }
            self.exerciseInfor = data.toExerciceInforViewable(with: images)
            self.completionHandler?(.success(true))
               print("done")
           }
    }
    
    var numberOfImages: Int {
        return exerciseInfor?.allImage?.count ?? 0
    }
    
    var numberOfEqupiment: Int{
        return exerciseInfor?.allEquiments.count ?? 0
    }
    
    var numberOfMuscles: Int{
        return exerciseInfor?.allMusclesList.count ?? 0
    }
    
    var topCellData:(title: String, category: String){
        return (exerciseInfor?.name ?? "", exerciseInfor?.categoryName ?? "")
    }
    
    func imageAtIndex(index: Int) -> String? {
        return self.exerciseInfor?.allImage?[index]
    }
    
    var description:String {
        return self.exerciseInfor?.description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) ?? ""
    }
    
    func equipmetAtIndex(index: Int) -> String? {
        return self.exerciseInfor?.allEquiments[index]
    }

    func muscelsAtIndex(index: Int) -> String? {
        return self.exerciseInfor?.allMusclesList[index]
   }
    
    
    
    
}
