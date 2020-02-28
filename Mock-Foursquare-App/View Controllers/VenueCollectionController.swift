//
//  VenueCollectionController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import DataPersistence
import AVFoundation

class VenueCollectionController: UIViewController {
    
    @IBOutlet var blurEffect: UIVisualEffectView!
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var viewForTV: UIView!
    
    public var venuePersistence: DataPersistence<Venue>
    public var collectionPersistence: DataPersistence<UserCollection>
    public var userCollection: UserCollection
    
    public var venueDetail: VenueDetail?
    
    private var venueCollection = [Venue]() {
        didSet {
            tableView.reloadData()
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
    }
    
    private var allVenues = [Venue]()
    
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
            allVenues = try venuePersistence.loadItems()
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
        venueCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "venueCollectionCell", for: indexPath) as? VenueCollectionTableCell else {
            fatalError()
        }
        let venue = venueCollection[indexPath.row]
        cell.configureCell(venue: venue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeVenue(atIndexPath: indexPath)
        }
    }
    
    private func removeVenue(atIndexPath indexPath: IndexPath) {
//        loadVenues()
        let venue = venueCollection[indexPath.row]

        guard let indexInAllVenues = allVenues.firstIndex(of: venue) else {
            return
        }
        venueCollection.remove(at: indexPath.row)
        
        do {
            try venuePersistence.deleteItem(at: indexInAllVenues)
        } catch {
            showAlert(title: "Error", message: "Could not delete Venue")
        }
        
    }
    
}

extension VenueCollectionController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let venue = venueCollection[indexPath.row]
        
        FoursquareAPIClient.getVenuePhotos(locationID: venue.id) { [weak self] (results) in
            switch results {
            case .failure(let appError):
                print("Failed to load venue details: \(appError)")
            case .success(let venueDetail):
                DispatchQueue.main.async {
                    self?.venueDetail = venueDetail
                }
            }
        }

        guard let venueDetail = venue.venueDetail else {
            return
        }
        
        guard let data = venue.venuePhoto else {
            return
        }
        
        guard let image = UIImage(data: data) else {
            return
        }
        
        let detailVC = DetailViewController(venuePersistence, collectionPersistence: collectionPersistence, venue: venueDetail, detail: venue, image: image, showPickerView: true)
        
        present(detailVC, animated: true)
    }
}


