//
//  UserCollection.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import UIKit

struct UserCollection: Codable & Equatable{
    let collectionName: String
    let pickedImage: Data
}
