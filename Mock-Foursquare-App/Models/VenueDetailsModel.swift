//
//  FourSquarePhotosModel.swift
//  Mock-Foursquare-App
//
//  Created by Gregory Keeley on 2/25/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct VenueDetail: Codable & Equatable {
    let response: Response
}
struct Response: Codable & Equatable {
    let venue: ResponseVenue
}
struct ResponseVenue: Codable & Equatable {
    let name: String
    let description: String?
    let photos: GroupsResponse
    let categories: [CategoryType]
}
struct GroupsResponse: Codable & Equatable {
    let groups: [Groups]
}
struct Groups: Codable & Equatable {
    let items: [Items]
}
struct Items: Codable & Equatable {
    let prefix: String
    let suffix: String
}

struct CategoryType: Codable & Equatable {
    let icon: PrefixSuffix
}

struct PrefixSuffix: Codable & Equatable {
    let prefix: String
}
