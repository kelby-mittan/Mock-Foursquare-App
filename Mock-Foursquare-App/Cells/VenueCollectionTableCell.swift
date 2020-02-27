//
//  VenueCollectionTableCell.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class VenueCollectionTableCell: UITableViewCell {

    @IBOutlet var venueImage: UIImageView!
    
    @IBOutlet var venueNameLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    func configureCell(venue: Venue) {
        self.venueNameLabel.text = venue.name
        self.addressLabel.text = venue.location.address
        //self.imageView?.image = image
    }
}
