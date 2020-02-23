//
//  TabBarController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    private lazy var mapVC: MapViewController = {
        let vc = MapViewController()
        vc.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        return vc
    }()
    
    private lazy var collectionsVC: UserCollectionsController = {
        let vc = UserCollectionsController()
        vc.tabBarItem = UITabBarItem(title: "Collections", image: UIImage(systemName: "folder.fill"), tag: 1)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [UINavigationController(rootViewController: mapVC), UINavigationController(rootViewController: collectionsVC)]
    }

}
