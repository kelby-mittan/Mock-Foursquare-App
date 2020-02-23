//
//  FoursquareSearch.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct FoursquareSearch: Codable {
    let response: Venues
}

struct Venues: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let id: String
    let name: String
    let location: LocationInfo
}

struct LocationInfo: Codable {
    let address: String
    let crossStreet: String
    let lat: Double
    let lng: Double
}
