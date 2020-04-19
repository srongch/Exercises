//
//  ExerciseDetailViewController+Layout.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

extension ExerciseDetailViewController {
    internal func createLayout() -> UICollectionViewLayout {
           let sectionProvider = { (sectionIndex: Int,
                layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in

                let sectionLayoutKind = Section.allCases[sectionIndex]
                switch sectionLayoutKind {
                case .title:
                   return self.creatOneColumSection(layoutEnvironment: layoutEnvironment)
                case .image:
                    return self.creatImageListSection(layoutEnvironment: layoutEnvironment, max: 1, min: 1, headerNeeded: false, isEmpty: self.viewModel.numberOfImages <= 0)
                case .description:
                    return self.creatListSection(layoutEnvironment: layoutEnvironment, max: 1, min: 1, headerNeeded: true)
                  case  .equipment, .muscles:
                    return self.creatListSection(layoutEnvironment: layoutEnvironment, max: 3, min: 2, headerNeeded: true)
               }
            }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
        }
        
        private func creatOneColumSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection{
            let isIpad = traitCollection.horizontalSizeClass == .regular
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
 
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(isIpad ? 0.3 : 0.6)), subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            
            return section
        }
    
    private func creatListSection(layoutEnvironment: NSCollectionLayoutEnvironment, max: CGFloat, min: CGFloat, headerNeeded:Bool ) -> NSCollectionLayoutSection{
  
        let column = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
            max : min)
        
        let width: NSCollectionLayoutDimension = column > 1 ? .estimated(200.0) : .fractionalWidth(1.0)
        let height: NSCollectionLayoutDimension = column > 1 ? .absolute(54) : .estimated(40.0)
        
        let size = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        let item = NSCollectionLayoutItem(layoutSize: size)

        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
       section.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 15.0, bottom: 0, trailing: 15.0)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HeaderView.className,
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = column > 1 ? .groupPaging : .none
          return section
    }
    
    private func creatImageListSection(layoutEnvironment: NSCollectionLayoutEnvironment, max: CGFloat, min: CGFloat, headerNeeded:Bool, isEmpty: Bool ) -> NSCollectionLayoutSection{
        
        var groupFractionalWidth: CGFloat  = 0.0
        var groupFractionalHeight: CGFloat = 0.0
        if !isEmpty {
            let isIpad = traitCollection.horizontalSizeClass == .regular
            groupFractionalWidth = isIpad ? 0.475 : 0.8
            groupFractionalHeight = isIpad ? 0.6 : 1.0
        }
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(groupFractionalWidth),
            heightDimension: .fractionalWidth(groupFractionalHeight))
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1)
        
        group.contentInsets = NSDirectionalEdgeInsets(top:10, leading: 10, bottom: isEmpty ? 0 : 20, trailing: 10 )
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior =  .continuous
        return section
    }
    
}

