//
//  TabBarController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import DataPersistence

class TabBarController: UITabBarController {

    public var venuePersistence = DataPersistence<Venue>(filename: "savedVenues.plist")
    public var collectionPersistence = DataPersistence<UserCollection>(filename: "savedCollections.plist")
    
    private lazy var mapVC: MapViewController = {
        let vc = MapViewController()
        vc.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        return vc
    }()
    
    private lazy var collectionsVC: UserCollectionsController = {
        let vc = UserCollectionsController(venuePersistence, collectionPersistence: collectionPersistence)
        vc.tabBarItem = UITabBarItem(title: "Collections", image: UIImage(systemName: "folder.fill"), tag: 1)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [UINavigationController(rootViewController: mapVC), UINavigationController(rootViewController: collectionsVC)]
    }

}
