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
    
    init(_ venuePersistence: DataPersistence<Venue>, collectionPersistence: DataPersistence<UserCollection>, venues: [VenueDetail]) {
        self.venuePersistence = venuePersistence
        self.collectionPersistence = collectionPersistence
        self.venueDetails = venues
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var venueDetails = [VenueDetail]() {
        didSet {
            dump(venueDetails)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(venueDetails)
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueDetails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }

}
