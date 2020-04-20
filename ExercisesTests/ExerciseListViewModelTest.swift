//
//  ExerciseListViewModelTest.swift
//  ExercisesTests
//
//  Created by Dumbo on 20/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

import XCTest
@testable import Exercises

class ExerciseListViewModelTest: XCTestCase {

    var fakeNetwork : FakeNetwork!
    var viewModel: ExerciseListViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fakeNetwork = FakeNetwork()
        viewModel = ExerciseListViewModel.init(network: fakeNetwork)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func getExerciseDetail(exercise: Exercise)-> ExerciceInforViewable{
       
        let categoryList = MockData.categoryList().toDictionary()
        let equipment = MockData.equimentList().toDictionary()
        let muslces = MockData.muscleList().toDictionary()
        let imageList = Image.imageList[exercise.id]
        
        let exerciseCategory = [exercise.categoryId].compactMap{categoryList[$0]}
        let exerciseequipment = exercise.equipmentIdList.compactMap{equipment[$0]}
        let exercisemuslces = exercise.musclesIdList.compactMap{muslces[$0]} +  exercise.musclesSecondaryIdList.compactMap{muslces[$0]}
        
        let exerciseModel = ExerciseCellModel.init(id: exercise.id, name: exercise.name, category: exerciseCategory, image: imageList, equiments: exerciseequipment, muscles: exercisemuslces, description: exercise.description)
        return exerciseModel
    }
    
    func testInitailFetchData() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let exp = expectation(description: "ExerciseListViewModel loadfinish")
         
        let selectedListIndex = 0
        let exerciseList = MockData.exerciseList(page: 1)
        let exerciceInforViewable = getExerciseDetail(exercise: exerciseList.list![selectedListIndex])
        
        viewModel.initialFetch { result in
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.filterComponents)
            
            XCTAssertNotNil(self.viewModel.musclesListManager.list)
            XCTAssertNotNil(self.viewModel.categoryListManager.list)
            XCTAssertNotNil(self.viewModel.equipmentListManager.list)
            XCTAssertNotNil(self.viewModel.exerciseListManager.list)
            
            XCTAssertEqual(self.viewModel.numberOfItem, exerciseList.list!.count, "mock data page 1 contains 2 exercise")
            let item = self.viewModel.itemAtIdex(index: selectedListIndex)
            
            XCTAssertEqual(exerciceInforViewable.id, item!.id)
            XCTAssertEqual(exerciceInforViewable.name, item!.name)
            XCTAssertEqual(exerciceInforViewable.categoryName, item!.categoryName)
            XCTAssertEqual(exerciceInforViewable.description, item!.description)
            XCTAssertNil(item!.allImage?.count, "initaily no image should be loaded")
            XCTAssertEqual(exerciceInforViewable.allEquiments, item!.allEquiments)
            XCTAssertEqual(exerciceInforViewable.allMusclesList, item!.allMusclesList)
            
            
            
            exp.fulfill()
        }
        XCTAssertTrue(self.viewModel.isLoading)
        XCTAssertEqual(self.viewModel.listState, ExerciseListViewModel.StateCase.all)
        
        //test navigation components
        XCTAssertNil(self.viewModel.filterComponents)
        XCTAssertNotNil(self.viewModel.detailComponent)
        
         wait(for: [exp], timeout: 10.0)
        
    }
    
    func testImageListLoading() throws {
        let exp = expectation(description: "ImageList loadfinish")
        let exerciseId = 1
        let imagesForId = Image.imageList[1]!
        
        print(imagesForId)
        XCTAssertNil(viewModel.loadImageForExercise(id: exerciseId))
        viewModel.fetchImageListAsync(exerciseId: exerciseId) { imageString in
            XCTAssertNotNil(self.viewModel.loadImageForExercise(id: exerciseId))
            XCTAssertEqual(imagesForId.first?.name, imageString)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }
    
    func testSearchExercise() throws {
        let searchString = "Cable"
        let itemIndex = 0
        let search = MockData.searchByTerm(term: searchString)
        let item = search.list![itemIndex].toExerciceInforViewable
        print(search)
        
        let firstPage = MockData.exerciseList(page: 1)
         let exp = expectation(description: "SearchExercise loadfinish")
        exp.expectedFulfillmentCount = 2
        viewModel.completionHandler = { result in
            if self.viewModel.search != nil {
                XCTAssertEqual(search.count, self.viewModel.numberOfItem)
                
                let searchItem = self.viewModel.itemAtIdex(index: itemIndex)
                XCTAssertEqual(item.name, searchItem?.name)
                XCTAssertEqual(item.id, searchItem?.id)
                self.viewModel.search = nil
                XCTAssertNil(self.viewModel.search)
                XCTAssertEqual(self.viewModel.listState,ExerciseListViewModel.StateCase.all)
            }else{
                XCTAssertEqual(firstPage.list?.count, self.viewModel.numberOfItem)
            }
            
            exp.fulfill()
        }
        
        viewModel.search = searchString
        XCTAssertNotNil(viewModel.search)
        XCTAssertEqual(viewModel.listState,ExerciseListViewModel.StateCase.search)
        
        wait(for: [exp], timeout: 10.0)
    }
    
    func testListFilter() {
        let filter = MockData.categoryList().list![0]
        let allFilter = Item.init(id: -1, name: "") // for reset filter
        
        let filterItems = MockData.exerciseList(filter: Filter.category(filter.id))
        let resetsList = MockData.exerciseList(page: 1)
        
        let exp = expectation(description: "ListFilter loadfinish")
        exp.expectedFulfillmentCount = 2
        viewModel.completionHandler = { result in
            
            if self.viewModel.selectedBodyPart!.id > 0  {
               XCTAssertEqual(filterItems.list?.count, self.viewModel.numberOfItem)
                //reset
                self.viewModel.selectedBodyPart = allFilter
                XCTAssertEqual(self.viewModel.selectedBodyPart?.id, allFilter.id)
            }else{
                 XCTAssertEqual(resetsList.list?.count, self.viewModel.numberOfItem)
            }
            
            exp.fulfill()
        }
        
        viewModel.selectedBodyPart = filter
        
        XCTAssertNotNil(viewModel.selectedBodyPart)
        XCTAssertEqual(viewModel.selectedBodyPart?.id, filter.id)
        
        
        
        wait(for: [exp], timeout: 10.0)
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
