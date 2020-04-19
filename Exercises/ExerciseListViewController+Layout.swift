//
//  ExerciseListViewController+Layout.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

extension ExerciseListViewController {
    
    internal func configureCollectionView() {
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionView.delegate = self
        collectionView.register(UINib(nibName: ExerciseCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ExerciseCollectionViewCell.className)
        collectionView.register(UINib(nibName: LoadingCell.className, bundle: nil), forCellWithReuseIdentifier: LoadingCell.className)
        collectionView.register(UINib(nibName: EmptyCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: EmptyCollectionViewCell.className)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .main:
                return self.createMainSection(layoutEnvironment: layoutEnvironment)
            case .reload:
                return self.creatLoadMoreSection()
            case .empty:
                return self.creatEmptySection()
            }
            
        }
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
        return section
    }
    
    private func createMainSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let columnCount = traitCollection.horizontalSizeClass == .compact ? 1 : 2
        var cellHeightRatio: CGFloat = traitCollection.horizontalSizeClass == .compact ? 0.5 : 0.2
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(cellHeightRatio)), subitem: item, count: columnCount)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0)
        return section
    }
}
