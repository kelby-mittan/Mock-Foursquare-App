//
//  MapViewController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    private let theMapView = TheMapView()
        
        private lazy var menuButton: UIBarButtonItem = {
            let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(menuButtonPressed(_:)))
            return button
        }()
        
        private lazy var venueSearchBar: UISearchBar = {
            let sb = UISearchBar()
            sb.placeholder = "search venue"
            return sb
        }()
        
        override func loadView() {
            view = theMapView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()

            theMapView.backgroundColor = .systemTeal
            setupNavBar()
        }
        
        private func setupNavBar() {
            navigationItem.setRightBarButton(menuButton, animated: true)
            navigationItem.titleView = venueSearchBar
    //        theMapView.locationSearchBar.trailingAnchor.constraint(equalTo: venueSearchBar.trailingAnchor).isActive = true
        }
        
        @objc private func menuButtonPressed(_ sender: UIBarButtonItem) {
            print("menu button pressed")
        }

}
