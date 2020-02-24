//
//  UserCollectionsController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class UserCollectionsController: UIViewController {
    
    let userCollectionsV = UserCollectionsView()
    
    override func loadView() {
        view = userCollectionsV
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCollectionsV.backgroundColor = .systemGray2
        userCollectionsV.collectionView.register(UsersCollectionsCell.self, forCellWithReuseIdentifier: "userCell")
        userCollectionsV.collectionView.dataSource = self
        userCollectionsV.collectionView.delegate = self
    }
    
    
}

extension UserCollectionsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as? UsersCollectionsCell else {
            fatalError("could not deque")
        }
        cell.backgroundColor = .systemBackground
        return cell
    }
}

extension UserCollectionsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1)) + 10
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
}
