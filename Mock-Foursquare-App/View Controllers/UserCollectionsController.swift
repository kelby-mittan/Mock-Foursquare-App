//
//  UserCollectionsController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import DataPersistence

class UserCollectionsController: UIViewController {
    
    let userCollectionsV = UserCollectionsView()
    
    override func loadView() {
        view = userCollectionsV
    }
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPressed(_:)))
        return button
    }()
    
    public var venuePersistence: DataPersistence<Venue>
    public var collectionPersistence: DataPersistence<UserCollection>
    
    init(_ venuePersistence: DataPersistence<Venue>, collectionPersistence: DataPersistence<UserCollection>) {
        self.venuePersistence = venuePersistence
        self.collectionPersistence = collectionPersistence
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCollectionsV.backgroundColor = .systemGray2
        navigationItem.setRightBarButton(addButton, animated: true)
        userCollectionsV.collectionView.register(UsersCollectionsCell.self, forCellWithReuseIdentifier: "userCell")
        userCollectionsV.collectionView.dataSource = self
        userCollectionsV.collectionView.delegate = self
        
    }
    
    @objc private func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add button pressed")
        
        let createStoryboard = UIStoryboard(name: "CreateCollection", bundle: nil)
        
        let createCollectionVC = createStoryboard.instantiateViewController(identifier: "CreateCollectionController", creator: { coder in
            
            return CreateCollectionController(coder: coder, venuePersistence: self.venuePersistence, collectionPersistence: self.collectionPersistence)
        })
        
//        let createCollectionNC = UINavigationController(rootViewController: createCollectionVC)
        
//        createCollectionVC.modalTransitionStyle
        navigationController?.pushViewController(createCollectionVC, animated: true)
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
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
