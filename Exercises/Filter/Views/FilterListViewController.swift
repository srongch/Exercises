//
//  FilterListViewController.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

protocol FilterListViewControllerResultDelegate {
    func didSelctedItem(_ viewControler: FilterListViewController, item: Identifiable)
}

class FilterListViewController: UIViewController {


    var viewModel: FilterListViewModel!
    var delegate: FilterListViewControllerResultDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.dataSource = dataSource
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FilterListViewController : UITableViewDelegate{
    //For single choice selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCellState(tableView, indexPath: indexPath, state: .selected)
        guard let item = self.viewModel.itemAtIndex(indexPath: indexPath) else {
           fatalError("no item at index")
        }
        
        self.delegate?.didSelctedItem(self, item: item)
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateCellState(tableView, indexPath: indexPath, state: .none)
    }
    
    func updateCellState(_ tableView: UITableView, indexPath: IndexPath, state: FilterCellState){
        let cell = tableView.cellForRow(at: indexPath) as? FilterViewCell
               cell?.updateState(state: state)
    }
}

extension FilterListViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterViewCell.className, for: indexPath) as? FilterViewCell else { return UITableViewCell() }
        guard let item = viewModel.itemAtIndex(indexPath: indexPath) else {
            return cell
        }
        cell.configure(item: item, state: self.viewModel.stateForItem(item: item))
        return cell
    
    }
}
