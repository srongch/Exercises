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
    

//    let cellHeightRatio: CGFloat = 0.3
    let cellInsect = NSDirectionalEdgeInsets.init(top: 5, leading: 20, bottom: 5, trailing: 20)

    var galleryCollectionView: UICollectionView! = nil
    
    var viewModel: ExerciseListViewModel!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //   fectch()
        self.viewModel = ExerciseListViewModel.init(network: ExerciseNetwork(provider: MoyaProvider<ExerciseApi>()))
//        
        self.viewModel.initialFetch(){ [weak self] result in
            switch result {
            case .success:
                guard let strongSelf = self else {return}
                strongSelf.galleryCollectionView.reloadData()
            case .failure(let error):
                print("Source of randomness failed: \(error)")
            }
        }
        configureCollectionView()
        configureSearchviewController()
//         self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
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

extension ExerciseListViewController {
    
    func configureSearchviewController(){
    // 1
    searchController.searchResultsUpdater = self
    // 2
    searchController.obscuresBackgroundDuringPresentation = false
    // 3
    searchController.searchBar.placeholder = "Search Exercise"
    // 4
    navigationItem.searchController = searchController
    // 5
    definesPresentationContext = true
    
    searchController.searchBar.scopeButtonTitles = []
    searchController.searchBar.delegate = self
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createLayout())
            collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            collectionView.backgroundColor = .secondarySystemGroupedBackground
            collectionView.delegate = self
            collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifer)
        
        collectionView.register(UINib(nibName: ExerciseCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ExerciseCollectionViewCell.className)
            collectionView.register(UINib(nibName: LoadingCell.className, bundle: nil), forCellWithReuseIdentifier: LoadingCell.className)
         collectionView.register(UINib(nibName: EmptyCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: EmptyCollectionViewCell.className)
        collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.prefetchDataSource = self
            galleryCollectionView = collectionView
//        galleryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(galleryCollectionView)
//
//       let guide = view.safeAreaLayoutGuide
//         NSLayoutConstraint.activate([
//            galleryCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            galleryCollectionView.leftAnchor.constraint(equalTo: guide.leftAnchor),
//            galleryCollectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
//            galleryCollectionView.rightAnchor.constraint(equalTo: guide.rightAnchor)
//            ])
        
        }
    
    private func createLayout() -> UICollectionViewLayout {
       return UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
                
//            if layoutEnvironment.traitCollection.userInterfaceStyle == .dark {
//                return sectionForUserInterfaceStyle(.dark)
//            } else {
//                return sectionForUserInterfaceStyle(.light)
//            }
            let sectionLayoutKind = Section.allCases[sectionIndex]
           // self.galleryCollectionView.isScrollEnabled = false
            switch sectionLayoutKind {
            case .main:
                return self.createMainSection(layoutEnvironment: layoutEnvironment)
            case .reload:
                return self.creatLoadMoreSection()
            case .empty:
            //    self.galleryCollectionView.isScrollEnabled = false
                return self.creatEmptySection()
        }
            
            
        }
  //      return layout
    
//        return UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
//            switch Section(rawValue: sectionNumber) {
//            case .main:
//                return self.createMainSection()
//            case .reload:
//                return self.creatLoadMoreSection()
//            default:
//                return nil
//            }
//        }
    }
    
    private func creatEmptySection()-> NSCollectionLayoutSection{
        return self.creatOneColumSection(height: .fractionalHeight(0.6))
    }
    
    private func creatLoadMoreSection()-> NSCollectionLayoutSection{
        return self.creatOneColumSection(height: .absolute(45))
    }
    
    private func creatOneColumSection(height: NSCollectionLayoutDimension) -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
       // section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 15.0, bottom: 5.0, trailing: 15.0)
        return section
    }
        
        private func createMainSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
            
            let columnCount = traitCollection.horizontalSizeClass == .compact ? 1 : 2
            let cellHeightRatio: CGFloat = traitCollection.horizontalSizeClass == .compact ? 0.35 : 0.2
//            if traitCollection.horizontalSizeClass == .regular {
//                // load slim view
//                print("ipad")
//                columnCount = 2
//            }
//            else {
//                print("iphone")
//                columnCount = 2
//                // load wide view
//            }
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(cellHeightRatio)), subitem: item, count: columnCount)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0)
            return section
//            section.orthogonalScrollingBehavior = .groupPaging
//            section
            
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        //    item.contentInsets = cellInsect
////            item.contentInsets = NSDirectionalEdgeInsets(
////            top: 2,
////            leading: 6,
////            bottom: 2,
////            trailing: 6)
//
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                   heightDimension: .fractionalWidth(CGFloat(cellHeightRatio)))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                           subitem: item, count: 2)
//
//            group.interItemSpacing = .fixed(CGFloat(10))
//
//            let section = NSCollectionLayoutSection(group: group)
//
//            let layout = UICollectionViewCompositionalLayout(section: section)
//            return layout
        }
    }

    


extension ExerciseListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.viewModel.nu
        let sectionLayoutKind = Section.allCases[section]
               switch sectionLayoutKind {
               case .main:
                return self.viewModel.numberOfItem()
               case .reload:
                   return self.viewModel.numberOfItem() > 0 ? 1 : 0
               case .empty:
                return self.viewModel.numberOfItem() > 0 ? 0 : 1
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
     //   cell.backgroundColor = .systemBlue
        //cell.backgroundColor = .systemRed
//        cell.loading()
        return cell
    }
    
    func loadingCellFor(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> LoadingCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.className, for: indexPath) as! LoadingCell
        //cell.backgroundColor = .systemRed
        cell.loading(finish: self.viewModel.allLoaded)
        return cell
    }
    func mainCellFor(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> ExerciseCollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCollectionViewCell.className, for: indexPath) as! ExerciseCollectionViewCell
        guard let exerciseModel = self.viewModel.itemAtIdex(index: indexPath.row) else {return cell}
        cell.configCell(model: exerciseModel)
        //config
        
        if ((exerciseModel.mainImage) == nil) {
          self.viewModel.fetchImageListAsync(exerciseId: exerciseModel.id){ result in
            cell.updateImage(urlString: result ?? "", for: exerciseModel.id) }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Begin asynchronously fetching data for the requested index paths.
        //   print("load more")
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
