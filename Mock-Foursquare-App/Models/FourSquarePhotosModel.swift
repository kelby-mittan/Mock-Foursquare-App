//
//  FourSquarePhotosModel.swift
//  Mock-Foursquare-App
//
//  Created by Gregory Keeley on 2/25/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation

struct FourSquarePhoto: Codable & Equatable {
    let response: Response
}
struct Response: Codable & Equatable {
    let venue: ResponseVenue
}
struct ResponseVenue: Codable & Equatable {
    let name: String
    let photos: PhotosResponse
}
struct PhotosResponse: Codable & Equatable {
    let groups: [Groups]
}
struct Groups: Codable & Equatable {
    let items: [Items]
}
struct Items: Codable & Equatable {
    let prefix: String
    let suffix: String
}

