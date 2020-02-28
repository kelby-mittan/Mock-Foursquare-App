//
//  MapViewController.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import MapKit
import DataPersistence
import ImageKit

class MapViewController: UIViewController {
    
    private var venuePersistence: DataPersistence<Venue>
    private var collectionPersistence: DataPersistence<UserCollection>
    
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
            loadVenueDetails(venueSearch: venues)
        }
    }
    
    private var venueDetails = [VenueDetail]() {
        didSet {
            print(venueDetails.count)
            theMapView.collectionView.reloadData()
        }
    }
    
    private var images = [UIImage]()
        
    private var image = UIImageView()
    
    private var locationSearch = ""
    private var venueSearch = ""
    
    public var annotations = [MKPointAnnotation]()
    
    private let locationSession = CoreLocationSession()
    private var userTrackingButton: MKUserTrackingButton!
    
    init(_ venuePersistence: DataPersistence<Venue>, collectionPersistence: DataPersistence<UserCollection>) {
         self.venuePersistence = venuePersistence
         self.collectionPersistence = collectionPersistence
         super.init(nibName: nil, bundle: nil)
         
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        theMapView.backgroundColor = .systemBackground
        setupNavBar()
        theMapView.mapView.delegate = self
        theMapView.locationSearchBar.delegate = self
        venueSearchBar.delegate = self
        theMapView.collectionView.delegate = self
        theMapView.collectionView.dataSource = self
        theMapView.collectionView.register(UINib(nibName: "VenueCVCell", bundle: nil), forCellWithReuseIdentifier: "venueCell")
        
        setupUserTrackingButton()
    }
    
    private func setupUserTrackingButton() {
        theMapView.mapView.showsUserLocation = true
        theMapView.mapView.userTrackingMode = .follow
        userTrackingButton = MKUserTrackingButton(frame: CGRect(x: 200, y: 150, width: 40, height: 40))
        theMapView.userTrackingButton.mapView = theMapView.mapView
        userTrackingButton.tintColor = .blue
        userTrackingButton.layer.cornerRadius = 4
        theMapView.mapView.addSubview(userTrackingButton)
    }
    
    private func setupNavBar() {
        navigationItem.setRightBarButton(menuButton, animated: true)
        navigationItem.titleView = venueSearchBar
    }
    
    
    @objc private func menuButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(ItemTableViewController(venuePersistence, collectionPersistence: collectionPersistence, venues: venueDetails, detail: venues, images: images), animated: true)
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
                            self?.venueDetails.append(venueDetails)
                            self?.loadImage(photoData: venueDetails)
                        }
                    }
                }
            }
        }
        
        func loadImage(photoData: VenueDetail) {
            image.getImage(with:  "\(photoData.response.venue.photos.groups.first?.items.first?.prefix ?? "")original\(photoData.response.venue.photos.groups.first?.items.first?.suffix ?? "")") { [weak self] (results) in
                switch results {
                case .failure(let appError):
                    print("error with collectionViewcell: \(appError)")
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.images.append(image)
                    }
                }
            }
        }
        
        private func makeAnnotations() {
            for venue in venues {
                let coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.subtitle = venue.id
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
            images.removeAll()
        }
    }

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

    }

    extension MapViewController: UISearchTextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard !(textField.text?.isEmpty ?? true) else {
                showAlert(title: "Location Field is Missing", message: "Please enter a location")
                return true }
            guard !venueSearch.isEmpty else {
                showAlert(title: "Search Field is Missing", message: "Please enter a search term")
                return true
            }
            locationSearch = textField.text?.lowercased() ?? ""
            loadVenues(city: locationSearch)

            textField.resignFirstResponder()
            return true
        }
    }


    // MARK: MapviewDelegate
    extension MapViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.red
                renderer.lineWidth = 4.0
                return renderer
        }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            mapView.removeOverlays(mapView.overlays)
            guard let annotation = view.annotation else {return}
            guard let location = (annotations.filter { $0.subtitle == annotation.subtitle }).first else { return }
            let sourceCoord = CLLocationCoordinate2D(latitude: 40.782865, longitude: -73.967544)
            let destinationCoord = location.coordinate
            let sourcePlacemark = MKPlacemark(coordinate: sourceCoord, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoord, addressDictionary: nil)
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            let sourceAnnotation = MKPointAnnotation()
            sourceAnnotation.title = ""
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.title = annotation.title ?? ""
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
            }
            theMapView.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .automobile
            let directions = MKDirections(request: directionRequest)
            directions.calculate {
                (response, error) -> Void in
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                let route = response.routes[0]
                self.theMapView.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                let rect = route.polyline.boundingMapRect
                self.theMapView.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
            
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
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            navigationController?.pushViewController(DetailViewController(venuePersistence, collectionPersistence: collectionPersistence, venue: venueDetails[indexPath.row], detail: venues[indexPath.row], image: images[indexPath.row], showPickerView: false), animated: true)
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
        cell.cellDelegate = self
        cell.configureCell(venueDetail: venueDetails[indexPath.row])
        //images.append(cell.image)
        cell.layer.cornerRadius = 4
        print(images.count)
        dump(images)
        return cell
    }
    
    
}

extension MapViewController: VenueCVCellDelegate {
    func loadVenueImages(_ collectionsCell: VenueCVCell, venueImage: UIImage) {
        //images.append(venueImage)
    }
    
    
}
