//
//  MapViewController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private let theMapView = TheMapView()
    override func loadView() {
        view = theMapView
    }
    
    private lazy var menuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(menuButtonPressed(_:)))
        return button
    }()
    
    private lazy var venueSearchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "search venue"
        return sb
    }()
    
    private var venues = [Venue]() {
        didSet {
            // TODO: enable this func to load collection view (when API limit resets)
//            loadVenueDetails(venueSearch: venues)
        }
    }
    private var venueDetails = [VenueDetail]() {
        didSet {
            print(venueDetails.count)
            theMapView.collectionView.reloadData()
        }
    }
    
    
    private var locationSearch = ""
    private var venueSearch = ""
    
    public var annotations = [MKPointAnnotation]()
    
    
 // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theMapView.backgroundColor = .systemBackground
        setupNavBar()
        
        theMapView.mapView.delegate = self
        theMapView.locationSearchBar.delegate = self
        
        theMapView.collectionView.delegate = self
        theMapView.collectionView.dataSource = self
        theMapView.collectionView.register(UINib(nibName: "VenueCVCell", bundle: nil), forCellWithReuseIdentifier: "venueCell")
        
                venueSearchBar.delegate = self
        //        loadVenues()
    }
    
    private func setupNavBar() {
        navigationItem.setRightBarButton(menuButton, animated: true)
        navigationItem.titleView = venueSearchBar
        
        //        let searchController = UISearchController()
        //        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        //        searchController.obscuresBackgroundDuringPresentation = false
        //        searchController.searchBar.placeholder = "search venues"
        //        self.navigationItem.searchController = searchController
        //        self.navigationItem.setRightBarButton(menuButton, animated: true)
        //        self.definesPresentationContext = true
        //        searchController.delegate = self
    }
    
    
    @objc private func menuButtonPressed(_ sender: UIBarButtonItem) {
        print("menu button pressed")
        navigationController?.pushViewController(ItemTableViewController(), animated: true)
        //        mediumMenu()
    }
    
    private func loadVenues(city: String) {
        clearSearch()
        print("searchQuery: \(venueSearch)")
        print("location: \(locationSearch)")
        FoursquareAPIClient.getVenues(location: city, search: venueSearch.lowercased()) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let venues):
                self?.venues = venues
                DispatchQueue.main.async {
                    self?.loadMapView()
                }
            }
        }
    }
    
    private func loadVenueDetails(venueSearch: [Venue]) {
        for venue in venueSearch {
            FoursquareAPIClient.getVenuePhotos(locationID: venue.id) { [weak self] (results) in
                switch results {
                case .failure(let appError):
                    print("Failed to load venue details: \(appError)")
                case .success(let venueDetails):
                    DispatchQueue.main.async {
                    self?.venueDetails = venueDetails

                    }
                }
            }
        }
    }
    private func makeAnnotations() {
        for venue in venues {
            let coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = venue.name
            annotations.append(annotation)
        }
    }
    
    private func loadMapView() {
        makeAnnotations()
        theMapView.mapView.addAnnotations(annotations)
        theMapView.mapView.showAnnotations(annotations, animated: true)
    }
    private func clearSearch() {
        annotations.removeAll()
        theMapView.mapView.removeAnnotations(theMapView.mapView.annotations)
        venues.removeAll()
        venueDetails.removeAll()
    }
}


// MARK: SearchFieldDelegate
//extension MapViewController: UISearchControllerDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("searchBarSearchButtonClicked")
//    }
//
//    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
//        print("searchBarResultsListButtonClicked")
//    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        print("updateSearchResults")
//    }
//}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        guard !locationSearch.isEmpty else {
            showAlert(title: "Location Field Missing", message: "Please enter a location to search")
            return
        }
        venueSearch = searchText
        loadVenues(city: locationSearch)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            guard let text = searchBar.text else { return }
            venueSearch = text
            searchBar.setShowsCancelButton(false, animated: true)
            print("didEndEditing(search)")
        }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("text field is \(textField.text ?? "empty")")
//    }
}

extension MapViewController: UISearchTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !venueSearch.isEmpty else {
            showAlert(title: "Search Field is Missing", message: "Please enter a search term")
            return true
        }
        locationSearch = textField.text?.lowercased() ?? ""
        loadVenues(city: locationSearch)
        // Note: leaving the text in this field, allows the user to quickly search a different venue type, without typing the city again
//        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
//        annotations.removeAll()
    }
}


// MARK: MapviewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("did select")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let identifier = "locationAnnotation"
        var annotationView: MKPinAnnotationView
        
        if let dequeView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            annotationView = dequeView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
}


// MARK: Collection View Delegate/Datasource
extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
}

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venueDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "venueCell", for: indexPath) as? VenueCVCell else {
            fatalError("Failed to dequeue to VenueCVCell")
        }
        cell.configureCell(photoData: venueDetails[indexPath.row])
//        cell.configureCell()
        cell.layer.cornerRadius = 4
        return cell
    }
    
    
}
