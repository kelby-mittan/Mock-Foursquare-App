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
    
    private var usersCollections = [UserCollection]() {
        didSet{
            userCollectionsV.collectionView.reloadData()
        }
    }
    
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
        
        loadUsersCollections()
        
    }
    
    private func loadUsersCollections() {
        do {
            usersCollections = try collectionPersistence.loadItems()
        } catch {
            print("could not get photos")
        }
    }
    
    @objc private func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add button pressed")
        
        let createStoryboard = UIStoryboard(name: "CreateCollection", bundle: nil)
        
        let createCollectionVC = createStoryboard.instantiateViewController(identifier: "CreateCollectionController", creator: { coder in
            
            return CreateCollectionController(coder: coder, venuePersistence: self.venuePersistence, collectionPersistence: self.collectionPersistence)
        })
        
        createCollectionVC.collectionDelegate = self
        
        //        let createCollectionNC = UINavigationController(rootViewController: createCollectionVC)
        
        //        createCollectionVC.modalTransitionStyle
        navigationController?.pushViewController(createCollectionVC, animated: true)
    }
    
    
}

extension UserCollectionsController: AddToCollection {
    
    func updateCollectionView(userCollection: UserCollection) {
        
        usersCollections.insert(userCollection, at: 0)
        do {
            try collectionPersistence.createItem(userCollection)
            showAlert(title: "Cool", message: "\(userCollection.collectionName) has been added to your collections")
        } catch {
            print("error saving collection")
        }
    }
    
}

extension UserCollectionsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as? UsersCollectionsCell else {
            fatalError("could not deque")
        }
        let userCollection = usersCollections[indexPath.row]
        
        cell.userCollection = userCollection
        cell.configureCell(for: userCollection)
        cell.cellDelegate = self
        cell.layer.cornerRadius = 20
        
        cell.backgroundColor = .systemBackground
        return cell
    }
}

extension UserCollectionsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//                    let noOfCellsInRow = 2
//
//                    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//
//                    let totalSpace = flowLayout.sectionInset.left
//                        + flowLayout.sectionInset.right
//                        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
//
//                    let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
//
//                    return CGSize(width: size, height: size)
        
        return CGSize(width: view.frame.width/2 - 20, height: view.frame.width/2.25 - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
    }
    
}

extension UserCollectionsController: CollectionCellDelegate {
    func didLongPress(_ collectionsCell: UsersCollectionsCell, collection: UserCollection) {
        print("delegate working")
        
        guard let indexPath = userCollectionsV.collectionView.indexPath(for: collectionsCell) else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        present(alertController, animated: true)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] alertAction in
            self?.deleteCollection(collection: collection)
            self?.usersCollections.remove(at: indexPath.row)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
    }
    
    private func deleteCollection(collection: UserCollection) {
        guard let index = usersCollections.firstIndex(of: collection) else {
            return
        }
        do {
            try collectionPersistence.deleteItem(at: index)
        } catch {
            showAlert(title: "Error", message: "Could not delete Book")
        }
    }
}
