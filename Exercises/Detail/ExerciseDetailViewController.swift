//
//  ExerciseDetailViewController.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController {

    enum Section: String,  CaseIterable {
        
        case title = "title"
        case image = "image"
        case description = "Description"
        case equipment = "Equiment"
        case muscles = "Muscles"
        
    }
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    var viewModel: ExerciseDetailViewModel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            // Configure Collection View
            collectionView.delegate = self
            collectionView.dataSource = self
            
            // Create Collection View Layout
            collectionView.collectionViewLayout = createLayout()
            collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
            
            // Register Collection View Cell
            collectionView.register(UINib(nibName: TitleCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: TitleCollectionViewCell.className)
            collectionView.register(UINib(nibName: ImageCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.className)
            collectionView.register(UINib(nibName: TextCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: TextCollectionViewCell.className)
            collectionView.contentInsetAdjustmentBehavior = .never
            
            collectionView.register(
                HeaderView.self,
                forSupplementaryViewOfKind: HeaderView.className,
                withReuseIdentifier: HeaderView.className)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.completionHandler = {[weak self] result in
            print("done")
            self?.loadingView.stopAnimating()
            self?.collectionView.reloadData()
        }
        self.viewModel.loadData()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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



extension ExerciseDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: HeaderView.className,
          for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }

        supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
        return supplementaryView
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        self.performSegue(withIdentifier: "detailSegue", sender: nil)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.viewModel.nu
        let sectionLayoutKind = Section.allCases[section]
               switch sectionLayoutKind {
               case .title:
                return 1
               case .image:
                return self.viewModel.numberOfImages
               case .description:
                return 1
               case .equipment:
                return self.viewModel.numberOfEqupiment
                case .muscles:
                return self.viewModel.numberOfMuscles
               }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionLayoutKind = Section.allCases[indexPath.section]
        switch sectionLayoutKind {
        case .title:
            return self.titleCellFor(collectionView, cellForItemAt: indexPath)
        case .image:
            return self.imageCellFor(collectionView, cellForItemAt: indexPath)
        case .description:
            return self.textCellFor(collectionView, cellForItemAt: indexPath,text: self.viewModel.description, style: .multiLine )
        case .equipment:
            return self.textCellFor(collectionView, cellForItemAt: indexPath,  text: self.viewModel.equipmetAtIndex(index: indexPath.row) ?? "", style: .oneLine)
        case .muscles:
            return self.textCellFor(collectionView, cellForItemAt: indexPath,  text: self.viewModel.muscelsAtIndex(index: indexPath.row) ?? "", style: .oneLine)
        }
    }
    
    func textCellFor(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, text: String, style: TextCellStyle) -> TextCollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.className, for: indexPath) as! TextCollectionViewCell
        cell.configure(text: text, style: style)
        return cell
    }
    
    func titleCellFor(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> TitleCollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.className, for: indexPath) as! TitleCollectionViewCell
        cell.configure(title: self.viewModel.topCellData.title, subTitle: self.viewModel.topCellData.category)
        cell.backgroundColor = .systemOrange
        return cell
    }
    
    func imageCellFor(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> ImageCollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.className, for: indexPath) as! ImageCollectionViewCell
        cell.configure(imageUrl: self.viewModel.imageAtIndex(index: indexPath.row))
        return cell
    }
    
}
