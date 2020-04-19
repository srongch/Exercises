//
//  ViewController.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit
import PromiseKit
import Moya

class ExerciseListViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case main = 0
        case reload = 1
        case empty = 2
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var collectionView: UICollectionView! = nil
    
    var viewModel: ExerciseListViewModel!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.viewModel = ExerciseListViewModel.init(network: ExerciseNetwork(provider: MoyaProvider<ExerciseApi>()))
//        
        self.viewModel.initialFetch(){ [weak self] result in
            AlertView.ifNeedShowAlert(for: self, result: result, errorClosure: {
               print("close")
                self?.viewModel.initialFetch(completionHandler: nil)
            }) {
                self?.collectionView.reloadData()
            }
        }
        configureCollectionView()
        configureSearchviewController()
    }
    
//     MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //         Get the new view controller using segue.destination.
        //         Pass the selected object to the new view controller.
        if segue.identifier == "filterIdentifer"{
            if let destVC = segue.destination as? UINavigationController,
                let vc = destVC.topViewController as? FilterListViewController {
                vc.delegate = self
                if let component = self.viewModel.filterComponents {
                    vc.viewModel = FilterListViewModel.init(filterList: component.filterList, preSelectedItem: component.preSelectedItem)
                }else{
                    fatalError("need a list")
                }
               
            }
        }else if segue.identifier == "detailSegue" {
            if let destVC = segue.destination as? ExerciseDetailViewController {
                let component = self.viewModel.detailComponent
                if let indexPath = sender as? IndexPath,
                    let item = self.viewModel.itemAtIdex(index: indexPath.row){
                    destVC.viewModel = ExerciseDetailViewModel.init(exerciseId: item.id, exerciseInforManger: component.exerciseInfoManager, imageListManager: component.exerciseImageListManager)
                }else{
                    destVC.viewModel = ExerciseDetailViewModel.init(exerciseId: 20, exerciseInforManger: component.exerciseInfoManager, imageListManager: component.exerciseImageListManager)
                }
            }
        }
        
    }
    }

extension ExerciseListViewController: FilterListViewControllerResultDelegate{
    func didSelctedItem(_ viewControler: FilterListViewController, item: Identifiable) {
        print(item)
        self.viewModel.selectedBodyPart = item
        viewControler.dismiss(animated: true, completion: nil)
    }
}

extension ExerciseListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionLayoutKind = Section.allCases[section]
               switch sectionLayoutKind {
               case .main:
                return self.viewModel.numberOfItem()
               case .reload:
                   return self.viewModel.shouldShowReloadCell ? 1 : 0
               case .empty:
                return self.viewModel.shouldShowSearchEmtpyCell ? 1: 0
               }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let sectionLayoutKind = Section.allCases[indexPath.section]
        switch sectionLayoutKind {
        case .main:
            return self.mainCellFor(collectionView, cellForItemAt: indexPath)
        case .reload:
            return self.loadingCellFor(collectionView, cellForItemAt: indexPath)
        case .empty:
            return self.emtpyCellFor(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func emtpyCellFor(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> EmptyCollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.className, for: indexPath) as! EmptyCollectionViewCell
        return cell
    }
    
    func loadingCellFor(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> LoadingCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.className, for: indexPath) as! LoadingCell
        cell.loading(finish: self.viewModel.allLoaded)
        return cell
    }
    func mainCellFor(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> ExerciseCollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCollectionViewCell.className, for: indexPath) as! ExerciseCollectionViewCell
        guard let exerciseModel = self.viewModel.itemAtIdex(index: indexPath.row) else {return cell}
        cell.configCell(model: exerciseModel)
        
        if ((exerciseModel.mainImage) == nil) {
          self.viewModel.fetchImageListAsync(exerciseId: exerciseModel.id){ result in
            cell.updateImage(urlString: result ?? "", for: exerciseModel.id) }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: {$0.section == 1}) {
            print("load more")
            self.viewModel.loadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let sectionLayoutKind = Section.allCases[indexPath.section]
        switch sectionLayoutKind {
        case .reload:
            print("will display reload")
            self.viewModel.loadMore()
        default:
            break
        }
    }
}
