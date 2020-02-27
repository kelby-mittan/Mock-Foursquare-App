//
//  ItemTableViewCell.swift
//  Mock-Foursquare-App
//
//  Created by Edward O'Neill on 2/25/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    public lazy var itemImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "camera.on.rectangle")
        return iv
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "location"
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        setupItemImage()
        setupTitleLabel()
        setupLocationLabel()
    }
    
    func setupItemImage() {
        contentView.addSubview(itemImage)
        
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemImage.topAnchor.constraint(equalTo: topAnchor),
            itemImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImage.heightAnchor.constraint(equalTo: heightAnchor),
            itemImage.widthAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: itemImage.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func setupLocationLabel() {
        contentView.addSubview(locationLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 13),
            locationLabel.leadingAnchor.constraint(equalTo: itemImage.trailingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func configureCell(photoData: VenueDetail, location: LocationInfo, image: UIImage) {
        self.titleLabel.text = photoData.response.venue.name
        self.locationLabel.text = location.address
        self.imageView?.image = image
    }
}
