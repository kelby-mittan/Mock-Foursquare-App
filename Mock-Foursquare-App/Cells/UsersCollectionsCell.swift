//
//  UsersCollectionsCell.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class UsersCollectionsCell: UICollectionViewCell {
    
    public lazy var venueImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo.fill")
        return iv
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
        setupVenueImageViewConstraints()
    }
    
    private func setupVenueImageViewConstraints() {
        addSubview(venueImage)
        venueImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            venueImage.topAnchor.constraint(equalTo: self.topAnchor),
            venueImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            venueImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            venueImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75)
        ])
    }
    
    
}
