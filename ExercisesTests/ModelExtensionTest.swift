//
//  ModelExtensionTest.swift
//  ExercisesTests
//
//  Created by Dumbo on 20/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import XCTest
@testable import Exercises

class ModelExtensionTest: XCTestCase {

    
    //Testing Model Computed Property
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
//    https://wger.de/api/v2/exercise/?page=3&status=2
    func testModelList() {
        
        let item = MockData.muscleList().list!
        
        var itemList1 = ModelList<Item>.init(count: item.count, next: "https://mock.test?page=2", previous: nil, list: item)
        let itemList2 = ModelList<Item>.init(count: item.count, next: "https://mock.test?page=3", previous: "https://mock.test", list: item)
        let itemList3 = ModelList<Item>.init(count: item.count, next: "https://mock.test?page=4", previous: "https://mock.test?page=2", list: item)
        XCTAssertNotNil(itemList1.nextPage)
        XCTAssertEqual(1, itemList1.currentPage)
        XCTAssertNil(itemList1.previousPage)
        
        XCTAssertEqual(2, itemList2.currentPage)
        XCTAssertNotNil(itemList2.nextPage)
        XCTAssertNil(itemList2.previousPage)
        
        XCTAssertEqual(3, itemList3.currentPage)
        XCTAssertNotNil(itemList3.nextPage)
        XCTAssertNotNil(itemList3.previousPage)
        
        itemList1.merge(newObject: itemList2)
        XCTAssertEqual(item.count * 2, itemList1.numberOfItem())
        XCTAssertEqual(2, itemList1.currentPage)
        
        let combine = item + item
        XCTAssertEqual(combine[3].name, itemList1.itemAtIdex(index: 3)?.name)
        
        let toDict = itemList1.toDictionary()
        XCTAssertNotNil(toDict[item[0].id])
        
    }
    
    func testExerciceInforViewable() {
        let item1 = Item.init(id: 1, name: "Item1")
        let item2 = Item.init(id: 2, name: "Item2")
        let id = 1
        let name = "Exercise1"
        let description = "<p>Testing excerscise1</p>"
        let cleanDescription = "Testing excerscise1"
        
        let image1 = Image.init(id: 1, image: "Image1", isMain: true, exercise: 1)
        let image2 = Image.init(id: 2, image: "Image2", isMain: false, exercise: 1)
        
        let exerciseCategory = [item1]
        let exerciseequipment = [item1, item2]
        let exercisemuslces = [item1, item2] +  [item1, item2]
        let imageList = [image1, image2]
        
        let exerciseModel = ExerciseCellModel.init(id:id, name:name, category: exerciseCategory, image: imageList, equiments: exerciseequipment, muscles: exercisemuslces, description: description)
        print(exerciseModel)
        
        XCTAssertEqual(id, exerciseModel.id)
        XCTAssertEqual(name, exerciseModel.name)
        
        XCTAssertEqual(cleanDescription, exerciseModel.cleanedDescription)
        XCTAssertNotNil(exerciseModel.allImage)
        XCTAssertEqual(imageList.map{$0.name}, exerciseModel.allImage!)
        
        XCTAssertEqual("Item1", exerciseModel.categoryName)
        
        XCTAssertNotNil( exerciseModel.mainImage)
        XCTAssertEqual(imageList.first!.name, exerciseModel.mainImage)
        
        XCTAssertEqual("🏋️Item1, Item2", exerciseModel.equimentsList)
        XCTAssertEqual("💪Item1, Item2, Item1, Item2", exerciseModel.musclesList)
        
        XCTAssertEqual(exerciseequipment.map{$0.name}, exerciseModel.allEquiments)
        XCTAssertEqual(exercisemuslces.map{$0.name}, exerciseModel.allMusclesList)
    
        
        
    }

    func testExerciceInforViewableNilCase() {
        let item1 = Item.init(id: 1, name: "Item1")
        let id = 1
        let name = "Exercise1"
        let description = "<p>Testing excerscise1</p>"
        let exerciseCategory = [item1]
        
        let exerciseModel1 = ExerciseCellModel.init(id:id, name:name, category: exerciseCategory, image: nil, equiments: nil, muscles: nil, description: description)
        
        XCTAssertNil(exerciseModel1.allImage)
        XCTAssertEqual("",exerciseModel1.musclesList)
        XCTAssertEqual("",exerciseModel1.equimentsList)
        
        XCTAssertEqual(0, exerciseModel1.allEquiments.count)
        XCTAssertEqual(0, exerciseModel1.allMusclesList.count)

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
