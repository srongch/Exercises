//
//  ExerciseDetailViewModelTest1.swift
//  ExercisesTests
//
//  Created by Dumbo on 20/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import XCTest
@testable import Exercises

class ExerciseDetailViewModelTest1: XCTestCase {

    var fakeNetwork = FakeNetwork()
    var viewModel: ExerciseDetailViewModel!
    var exerciseId: Int = 1
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let exerciseInforManger = ExerciseInfoManager.init(networkManager: fakeNetwork)
        let imageListManager = ExerciseImageListManager.init( network: fakeNetwork)
        
        viewModel = ExerciseDetailViewModel.init(exerciseId: exerciseId, exerciseInforManger: exerciseInforManger, imageListManager: imageListManager)
    }
    
     func testInitailFetchData() throws {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct results.
        let exp = expectation(description: "ExerciseDetailViewModel loadfinish")
        let imageList = Image.imageList[exerciseId] ?? []
        let mockData = MockData.getExercisebyId(id: exerciseId).toExerciceInforViewable(with: imageList)
            print(mockData)
            
            viewModel.completionHandler = { results in
                XCTAssertEqual(mockData.allImage?.count, self.viewModel.numberOfImages)
                XCTAssertEqual(mockData.allEquiments.count, self.viewModel.numberOfEqupiment)
                 XCTAssertEqual(mockData.allMusclesList.count, self.viewModel.numberOfMuscles)
                XCTAssertEqual(mockData.name, self.viewModel.topCellData.title)
                XCTAssertEqual(mockData.categoryName, self.viewModel.topCellData.category)
                
                XCTAssertEqual(imageList[1].name,self.viewModel.imageAtIndex(index: 1))
                XCTAssertEqual(mockData.cleanedDescription, self.viewModel.description)
                XCTAssertEqual(mockData.allEquiments[1], self.viewModel.equipmetAtIndex(index: 1))
                XCTAssertEqual(mockData.allMusclesList[1], self.viewModel.muscelsAtIndex(index: 1))
                
                exp.fulfill()
            }
        
        viewModel.loadData()
             wait(for: [exp], timeout: 10.0)
            
        }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
