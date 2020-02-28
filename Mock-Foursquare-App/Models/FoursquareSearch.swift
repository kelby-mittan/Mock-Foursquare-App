//
//  FoursquareSearch.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct FoursquareSearch: Codable & Equatable {
    let response: Venues
}

struct Venues: Codable & Equatable {
    let venues: [Venue]
}

struct Venue: Codable & Equatable {
    let id: String
    let name: String
    let location: LocationInfo
    let customCategory: String?
    let venuePhoto: Data?
    let description: String?
}

struct LocationInfo: Codable & Equatable {
    let address: String?
    let crossStreet: String?
    let lat: Double
    let lng: Double
}
