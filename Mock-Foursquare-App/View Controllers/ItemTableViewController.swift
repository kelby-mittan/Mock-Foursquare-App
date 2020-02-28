//
//  ItemTableViewController.swift
//  Mock-Foursquare-App
//
//  Created by Edward O'Neill on 2/25/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import DataPersistence

class ItemTableViewController: UITableViewController {
    
    private var venuePersistence: DataPersistence<Venue>
    private var collectionPersistence: DataPersistence<UserCollection>
    
    init(_ venuePersistence: DataPersistence<Venue>, collectionPersistence: DataPersistence<UserCollection>, venues: [VenueDetail], detail: [Venue], images: [UIImage]) {
        self.venuePersistence = venuePersistence
        self.collectionPersistence = collectionPersistence
        self.venueDetails = venues
        self.locationDetails = detail
        self.images = images
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var images = [UIImage]() {
        didSet {
            dump(images.count)
        }
    }
    
    private var venueDetails = [VenueDetail]() {
        didSet {
//            dump(venueDetails)
        }
    }
    
    private var locationDetails = [Venue]() {
        didSet {
//            dump(locationDetails)
        }
    }
    
    private var collectionDetails = [UserCollection]() {
        didSet {
//            dump(collectionDetails)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        dump(venueDetails)
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueDetails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ItemTableViewCell else { fatalError("you messted up making cell") }
        cell.configureCell(photoData: venueDetails[indexPath.row], location: locationDetails[indexPath.row].location, image: images[indexPath.row]) // image: images[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigationController?.pushViewController(DetailViewController(), animated: true)
        navigationController?.pushViewController(DetailViewController(venuePersistence, collectionPersistence: collectionPersistence, venue: venueDetails[indexPath.row], detail: locationDetails[indexPath.row], image: images[indexPath.row], showPickerView: false), animated: true) // , image: images[indexPath.row]
    }

}
