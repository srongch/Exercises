//
//  FilterViewControllerTest.swift
//  ExercisesTests
//
//  Created by Dumbo on 20/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import XCTest
@testable import Exercises

class FilterViewControllerTest: XCTestCase {

    var fakeNetwork: FakeNetwork!
    var categoryManager: CategoryListManager!
    private let group = DispatchGroup()
    private let mainQueue = DispatchQueue.main
    override func setUpWithError() throws {
        self.fakeNetwork = FakeNetwork()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.categoryManager = CategoryListManager.init(network: fakeNetwork)
        
    }
    
    func testFilterModel() throws {
        let exp = expectation(description: "CategoryListManager loadfinish")
        self.categoryManager.load(dispatchGroup: group)
        group.notify(queue: mainQueue) {
            exp.fulfill()
        }
        
        let categorylist = MockData.categoryList()
        let selected = categorylist.list![1]
            
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            XCTAssertNotNil(self.categoryManager.list?.list)
            
            let filterViewModel = FilterListViewModel.init(filterList: (self.categoryManager.list?.list)!, preSelectedItem: selected)
            XCTAssertEqual(categorylist.count, filterViewModel.numberOfRow)
            XCTAssertNotNil(filterViewModel.itemAtIndex(indexPath: IndexPath.init(row: 0, section: 0)))
            XCTAssertEqual(filterViewModel.itemAtIndex(indexPath: IndexPath.init(row: 0, section: 0))?.id, categorylist.list![0].id)
            XCTAssertTrue(filterViewModel.stateForItem(item: selected) == .selected)
            XCTAssertTrue(filterViewModel.stateForItem(item: categorylist.list![2]) == .none)
        }
        
    }

//
//    func stateForItem(item: Identifiable) -> FilterViewCell.CellState{
//        return preSelectedItem?.id == item.id ? .selected : .none
//    }

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
