//
//  UsersCollectionsCell.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class UsersCollectionsCell: UICollectionViewCell {
    
    public lazy var collectionImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo.fill")
        return iv
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "this is the title"
        label.contentMode = .center
        return label
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
        setupTitleLabelConstraints()
    }
    
    private func setupVenueImageViewConstraints() {
        addSubview(collectionImage)
        collectionImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionImage.topAnchor.constraint(equalTo: self.topAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75)
        ])
    }
    
    private func setupTitleLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: collectionImage.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configureCell(for collection: UserCollection) {
        layer.cornerRadius = 20
        titleLabel.text = collection.collectionName
        
        guard let image = UIImage(data: collection.pickedImage) else {
            return
        }
        collectionImage.image = image
        
    }
}
