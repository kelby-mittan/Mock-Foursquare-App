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

class DetailViewController: UIViewController {

    let detailView = DetailView()
    var collectionName = [UserCollection]() {
        didSet {
            detailView.savePicker.reloadAllComponents()
        }
    }
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
    
    init(_ venuePersistence: DataPersistence<Venue>, collectionPersistence: DataPersistence<UserCollection>, venue: VenueDetail, detail: Venue, image: UIImage, showPickerView: Bool) { // , image: UIImage
        self.venuePersistence = venuePersistence
        self.collectionPersistence = collectionPersistence
        self.venueDetail = venue
        self.locationDetail = detail
        self.image = image
        
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
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didSaveItem(_:)))
        }
        
        loadCollection()
        detailView.savePicker.dataSource = self
        detailView.savePicker.delegate = self
        detailView.titleLabel.text = venueDetail.response.venue.name
        detailView.addressLabel.text = locationDetail.location.address
        detailView.descriptionTextView.text = venueDetail.response.venue.description
        detailView.itemImage.image = image
        // Do any additional setup after loading the view.
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
        
        let createdVenue = Venue(id: locationDetail.id, name: venueDetail.response.venue.name, location: locationDetail.location, customCategory: pickedCollection, venuePhoto: resizedImageData, description: venueDetail.response.venue.description)
        do {
            try venuePersistence.createItem(createdVenue)
        } catch {
            print("could not create venue")
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
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
