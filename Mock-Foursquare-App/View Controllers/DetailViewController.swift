//
//  DetailViewController.swift
//  Mock-Foursquare-App
//
//  Created by Edward O'Neill on 2/25/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import DataPersistence
import AVFoundation
import MapKit

class DetailViewController: UIViewController {

    let detailView = DetailView()
    var collectionName = [UserCollection]() {
        didSet {
            detailView.savePicker.reloadAllComponents()
        }
    }
    
    private lazy var swipeGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.addTarget(self, action: #selector(goToMapView))
        gesture.direction = .left
        return gesture
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(goToMapView))
        return gesture
    }()
    
    private var venuePersistence: DataPersistence<Venue>
    private var collectionPersistence: DataPersistence<UserCollection>
        
    private var venueDetail: VenueDetail
    
    private var locationDetail: Venue
    
    private var image: UIImage!
    
    private var showPickerView = false
    
    private var collectionDetails = [UserCollection]() {
        didSet {
//            dump(collectionDetails)
        }
    }
    
    private var pickedCollection = ""
    
    private var venueAnnotation = MKPointAnnotation()
    
    init(_ venuePersistence: DataPersistence<Venue>, collectionPersistence: DataPersistence<UserCollection>, venue: VenueDetail, detail: Venue, image: UIImage, showPickerView: Bool) { // , image: UIImage
        self.venuePersistence = venuePersistence
        self.collectionPersistence = collectionPersistence
        self.venueDetail = venue
        self.locationDetail = detail
        self.image = image
        self.showPickerView = showPickerView
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(detailView)
        if showPickerView {
            detailView.savePicker.isHidden = true
            detailView.itemImage.isUserInteractionEnabled = true
            detailView.itemImage.addGestureRecognizer(tapGesture)
        } else {
            
            let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didSaveItem(_:)))
            let createButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPressed(_:)))
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didSaveItem(_:)))
            navigationItem.setRightBarButtonItems([createButton,saveButton], animated: true)
        }
        
        loadCollection()
        detailView.savePicker.dataSource = self
        detailView.savePicker.delegate = self
        detailView.titleLabel.text = venueDetail.response.venue.name
        detailView.addressLabel.text = locationDetail.location.address
        detailView.descriptionTextView.text = venueDetail.response.venue.description
        detailView.itemImage.image = image
        // Do any additional setup after loading the view.
        detailView.itemImage.isUserInteractionEnabled = true
        detailView.mapView.delegate = self
        detailView.mapView.showsUserLocation = true
        detailView.itemImage.addGestureRecognizer(swipeGesture)
        detailView.mapSateliteSegmentC.addTarget(self, action: #selector(segmentControlChanged(_:)), for: .valueChanged)
    }
    
    func loadCollection() {
        do {
            print("I was here")
            let collectionName = try collectionPersistence.loadItems()
            self.collectionName = collectionName
        } catch {
            print("\(error)")
        }
    }
    
    @objc func didSaveItem(_ sender: UIBarButtonItem) {
        print(pickedCollection)
        guard let image = image else {
            showAlert(title: "Yo....", message: "Please Select a Picture for Collection")
            return
        }
        
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        
        guard let resizedImageData = resizeImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let createdVenue = Venue(id: locationDetail.id, name: venueDetail.response.venue.name, location: locationDetail.location, customCategory: pickedCollection, venuePhoto: resizedImageData, description: venueDetail.response.venue.description, venueDetail: venueDetail)
        do {
            try venuePersistence.createItem(createdVenue)
        } catch {
            print("could not create venue")
        }
        navigationItem.rightBarButtonItems?[1].isEnabled = false
    }
    
    @objc private func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add button pressed")
        
        let createStoryboard = UIStoryboard(name: "CreateCollection", bundle: nil)
        
        let createCollectionVC = createStoryboard.instantiateViewController(identifier: "CreateCollectionController", creator: { coder in
            
            return CreateCollectionController(coder: coder, venuePersistence: self.venuePersistence, collectionPersistence: self.collectionPersistence)
        })
        createCollectionVC.selectedImage = image
        createCollectionVC.collectionDelegate = self
        createCollectionVC.venue = locationDetail
        createCollectionVC.venueDetail = venueDetail
        navigationController?.pushViewController(createCollectionVC, animated: true)
    }
    
    @objc private func goToMapView() {
        print("swiped")
        loadMapView()
        UIView.transition(with: detailView.itemImage, duration: 0.75, options: [.transitionFlipFromTop], animations: {
            self.detailView.itemImage.isHidden = true
            self.detailView.mapView.isHidden = false
            self.detailView.mapSateliteSegmentC.isHidden = false
        }, completion: nil)
    }
    
    @objc func segmentControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0:
                detailView.mapView.mapType = .standard
            case 1:
                detailView.mapView.mapType = .hybrid
            default:
                break
            }
    }
    
    private func loadMapView() {
        let coordinate = CLLocationCoordinate2D(latitude: locationDetail.location.lat, longitude: locationDetail.location.lng)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = locationDetail.name
        venueAnnotation = annotation
        detailView.mapView.addAnnotation(annotation)
        detailView.mapView.showAnnotations([annotation], animated: true)
    }

}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return collectionName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = collectionName[row]
        pickedCollection = selected.collectionName
        print(selected)
//        let selected = dataSource[row]
//        bestseller.collectionView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(collectionName[row])
        pickedCollection = collectionName[row].collectionName
        return collectionName[row].collectionName
    }
    
}

extension DetailViewController: AddToCollection {
    
    func updateCollectionView(userCollection: UserCollection) {
        
        var usersCollections = [UserCollection]()
        
        do {
            usersCollections = try collectionPersistence.loadItems()
        } catch {
            print("could not load collections")
        }
        
        usersCollections.insert(userCollection, at: 0)
        do {
            try collectionPersistence.createItem(userCollection)
        } catch {
            print("error saving collection")
        }
    }
    
}

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
            renderer.lineWidth = 4.0
            return renderer
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.removeOverlays(mapView.overlays)
        guard let annotation = view.annotation else {return}
        
        let coordinate = CLLocationCoordinate2D(latitude: locationDetail.location.lat, longitude: locationDetail.location.lng)
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = coordinate
        annotation1.title = venueDetail.response.venue.name
        let location = venueAnnotation
        let sourceCoord = mapView.userLocation
        let destinationCoord = location.coordinate
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoord.coordinate, addressDictionary: nil)
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
        detailView.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
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
            self.detailView.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.detailView.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "annotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let endpoint = "\(venueDetail.response.venue.categories.first?.icon.prefix ?? "")bg_32.png"
            let imageUrl = URL(string: endpoint)!
            let imageData = try! Data(contentsOf: imageUrl)
            let annotationImage = UIImage(data: imageData)

            annotationView?.glyphImage = annotationImage
            annotationView?.image = annotationImage
            annotationView?.glyphTintColor = .systemOrange
            annotationView?.markerTintColor = .systemTeal
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }
}
