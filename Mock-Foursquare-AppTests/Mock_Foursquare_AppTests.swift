//
//  Mock_Foursquare_AppTests.swift
//  Mock-Foursquare-AppTests
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import XCTest
@testable import Mock_Foursquare_App

class Mock_Foursquare_AppTests: XCTestCase {

    func testJSONStarbucks() {
        
        
        let jsonData = """
        {
        "meta": {
            "code": 200,
            "requestId": "5e5191c8df2774001bf56295"
        },
        "response": {
            "venues": [
                {
                    "id": "5c13bf838afbe0002de55061",
                    "name": "Starbucks Reserve Roastery",
                    "location": {
                        "address": "61 9th Ave",
                        "crossStreet": "at W 15th St",
                        "lat": 40.74166158826782,
                        "lng": -74.00507982765883,
                        "labeledLatLngs": [
                            {
                                "label": "display",
                                "lat": 40.74166158826782,
                                "lng": -74.00507982765883
                            }
                        ],
                        "postalCode": "10011",
                        "cc": "US",
                        "city": "New York",
                        "state": "NY",
                        "country": "United States",
                        "formattedAddress": [
                            "61 9th Ave (at W 15th St)",
                            "New York, NY 10011",
                            "United States"
                        ]
                    },
                    "categories": [
                        {
                            "id": "4bf58dd8d48988d1e0931735",
                            "name": "Coffee Shop",
                            "pluralName": "Coffee Shops",
                            "shortName": "Coffee Shop",
                            "icon": {
                                "prefix": "https://ss3.4sqi.net/img/categories_v2/food/coffeeshop_",
                                "suffix": ".png"
                            },
                            "primary": true
                        }
                    ],
                    "referralId": "v-1582403930",
                    "hasPerk": false
            }]
            }
        }
        """.data(using: .utf8)!
        
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
        
        let expectedLat = 40.74166158826782
        
        do {
            let foursquare = try JSONDecoder().decode(FoursquareSearch.self, from: jsonData)
            let supLat = foursquare.response.venues.first?.location.lat ?? 0.0
            XCTAssertEqual(expectedLat, supLat)
        } catch {
            XCTFail("decoding error: \(error)")
        }
        
    }
    
    func testAPIClient() {
            
    //        let expectedLatitude = 40.745835357994196
    //        let expTitle = "Ruth's Chris Steak House"
            
            FoursquareAPIClient.getVenues(location: "new york", search: "steak house") { (result) in
                switch result {
                case .failure(let error):
                    XCTFail("error: \(error)")
                case .success(let venues):
                    let count = venues.count
                    XCTAssertEqual(50, count)
                }
            }
        }

}
