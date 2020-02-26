//
//  VenueCollectionController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import DataPersistence

class VenueCollectionController: UIViewController {
    
    @IBOutlet var blurEffect: UIVisualEffectView!
    
    @IBOutlet var tableView: UITableView!
    
    public var venuePersistence: DataPersistence<Venue>
    public var collectionPersistence: DataPersistence<UserCollection>
    
    init?(coder: NSCoder, venuePersistence: DataPersistence<Venue>, collectionPersistence: DataPersistence<UserCollection>) {
        self.venuePersistence = venuePersistence
        self.collectionPersistence = collectionPersistence
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(VenueCollectionTableCell.self, forCellReuseIdentifier: "venueTableCell")
        blurEffect.isHidden = true
        tableView.rowHeight = 60
    }
    
    @IBAction func collapseButtonPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true)
    }
    

}

extension VenueCollectionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "venueCollectionCell", for: indexPath) as? VenueCollectionTableCell else {
            fatalError()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension VenueCollectionController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


