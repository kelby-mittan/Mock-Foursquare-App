//
//  CollectionViewCell.swift
//  Mock-Foursquare-App
//
//  Created by Gregory Keeley on 2/25/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import ImageKit

class VenueCVCell: UICollectionViewCell {
    
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var venueImage: UIImageView!
    
    //TODO: Get image endpoint for image, along with venue name
//   func configureCell() {
//    venueLabel.text = "Venu"
//        venueImage.getImage(with: "") { (results) in
//            switch results {
//            case .failure(let appError):
//                print("error with collectionViewcell: \(appError)")
//            case .success(let image):
//                DispatchQueue.main.async {
//                self.venueImage.image = image
//                }
//            }
//        }
//    }
       func configureCell() {
        venueLabel.text = "Venue"
//        venueImage.image = UIImage(systemName: "photo.fill")
        }
}
