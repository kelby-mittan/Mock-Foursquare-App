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

    @IBOutlet var viewForTV: UIView!
    
    public var venuePersistence: DataPersistence<Venue>
    public var collectionPersistence: DataPersistence<UserCollection>
    public var userCollection: UserCollection
    
    private var venueCollection = [Venue]() {
        didSet {
            tableView.reloadData()
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
    }
    
    init?(coder: NSCoder, venuePersistence: DataPersistence<Venue>, collectionPersistence: DataPersistence<UserCollection>, userCollection: UserCollection) {
        self.venuePersistence = venuePersistence
        self.collectionPersistence = collectionPersistence
        self.userCollection = userCollection
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        blurEffect.isHidden = true
        tableView.rowHeight = 60
        viewForTV.layer.cornerRadius = 15
        loadVenues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewForTV.layer.cornerRadius = 20
    }
    
    private func loadVenues() {
        do {
            venueCollection = try venuePersistence.loadItems().filter { $0.customCategory == userCollection.collectionName }
        } catch {
            print("could not load venues")
        }
    }
//    @IBAction func collapsePressed(_ sender: UIButton) {
//        self.dismiss(animated: true)
//    }
    
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


