//
//  ExerciseListViewController+SearchViewController.swift
//  Exercises
//
//  Created by Dumbo on 18/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

extension ExerciseListViewController{
    
    @objc func searchExercise(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            self.viewModel.search = nil
            return
        }
        self.viewModel.search = query
        print(query)
    }
}

extension ExerciseListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let delay = searchBar.text == nil ? 0 : 0.3
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchExercise(_:)), object: searchBar)
      perform(#selector(self.searchExercise(_:)), with: searchBar, afterDelay: delay)
  }
}

extension ExerciseListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        self.searchExercise(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
