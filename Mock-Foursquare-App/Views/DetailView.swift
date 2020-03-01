//
//  DetailView.swift
//  Mock-Foursquare-App
//
//  Created by Edward O'Neill on 2/25/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import MapKit

class DetailView: UIView {

    public lazy var itemImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "camera.on.rectangle")
        return iv
    }()
    
    public lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.isHidden = true
        return mv
    }()
    
    public lazy var mapSateliteSegmentC: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Map","Satelite"])
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .lightGray
        sc.tintColor = .darkGray
        sc.isHidden = true
        return sc
    }()

    
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textAlignment = .center
        return label
    }()
    
    public lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "address"
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    public lazy var savePicker: UIPickerView! = {
        let pv = UIPickerView(frame: CGRect.zero)
        pv.backgroundColor = .systemBackground
        return pv
    }()
    
    public lazy var descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Peter Luger Steak House has been serving the finest steaks since 1887. We choose from only the finest USDA PRIME meat available. The selection process is crucial and therefore is done only by members of the family who visit the wholesale markets on a daily basis."
        tv.isEditable = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupImageViewConstraints()
        setupMapViewConstraints()
        setupTitleViewConstraints()
        setupAddressViewConstraints()
        setupPickerViewConstraints()
        setupDescriptionViewConstraints()
        setupSegmentedControlConstraints()
    }
    
    private func setupImageViewConstraints() {
        addSubview(itemImage)
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            itemImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupMapViewConstraints() {
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: itemImage.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: itemImage.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: itemImage.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: itemImage.bottomAnchor)
        ])
    }
    
    private func setupTitleViewConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupAddressViewConstraints() {
        addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            addressLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupDescriptionViewConstraints() {
        addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: savePicker.topAnchor)
        ])
    }
    
    private func setupPickerViewConstraints() {
        addSubview(savePicker)
        savePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            savePicker.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 75),
            savePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            savePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            savePicker.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupSegmentedControlConstraints() {
        addSubview(mapSateliteSegmentC)
        mapSateliteSegmentC.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapSateliteSegmentC.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10),
            mapSateliteSegmentC.centerXAnchor.constraint(equalTo: centerXAnchor),
            mapSateliteSegmentC.widthAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 0.5)
        ])
    }

}
