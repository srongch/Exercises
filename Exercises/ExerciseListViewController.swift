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

    let cellHeightRatio: CGFloat = 0.3
    let cellInsect = NSDirectionalEdgeInsets.init(top: 5, leading: 20, bottom: 5, trailing: 20)

    var galleryCollectionView: UICollectionView! = nil
    
    var viewModel: ExerciseListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //   fectch()
        self.viewModel = ExerciseListViewModel.init(network: ExerciseNetwork(provider: MoyaProvider<ExerciseApi>()))
        
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
    }
}

extension ExerciseListViewController {
    func configureCollectionView() {
            let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
            collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            collectionView.backgroundColor = .systemBackground
            collectionView.delegate = self
            collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifer)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.prefetchDataSource = self
            galleryCollectionView = collectionView
            view.addSubview(collectionView)
        }
        
        private func createLayout() -> UICollectionViewLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = cellInsect
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(CGFloat(cellHeightRatio)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item, count: 1)
            
            group.interItemSpacing = .fixed(CGFloat(10))
            
            let section = NSCollectionLayoutSection(group: group)
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }
    }

    


extension ExerciseListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.viewModel.nu
        return section == 0 ? self.viewModel.numberOfItem() : 1
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifer, for: indexPath) as! ImageCell
        
        switch indexPath.section {
        case 0:
            let exercise = self.viewModel.itemAtIdex(index: indexPath.row)
            
            //config
            
            if let imageList = self.viewModel.loadImageForExercise(id: exercise.id) {
                print("exsit")
            }else{
                self.viewModel.fetchImageListAsync(exerciseId: exercise.id){ result in
                    print("loaded")
                }
            }
             cell.featuredPhotoView.backgroundColor = .systemBlue
        default:
             cell.featuredPhotoView.backgroundColor = .systemRed
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Begin asynchronously fetching data for the requested index paths.
     //   print("load more")
        if indexPaths.contains(where: {$0.section == 1}) {
            print("load more")
            self.viewModel.fetchExercise()
        }
        
//        for indexPath in indexPaths {
//            _ =   self.viewModel.loadImage(at: indexPath, size: cellSize, notifiedWhenFinish: true)
//        }
    }
}
