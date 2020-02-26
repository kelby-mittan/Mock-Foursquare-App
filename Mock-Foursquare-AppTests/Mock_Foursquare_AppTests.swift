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
    
    func testVenuePhotoModel() {
        let jsonData = """
        {
            "meta": {
                "code": 200,
                "requestId": "5e55d2701a4b0a001b3fd627"
            },
            "response": {
                "venue": {
                    "id": "3fd66200f964a5209beb1ee3",
                    "name": "Peter Luger Steak House",
                    "contact": {
                        "phone": "7183877400",
                        "formattedPhone": "(718) 387-7400",
                        "instagram": "peterlugersteakhouse",
                        "facebook": "243860423562",
                        "facebookName": "Peter Luger Steak House Est. 1887"
                    },
                    "location": {
                        "address": "178 Broadway",
                        "crossStreet": "at Driggs Ave",
                        "lat": 40.70995790682886,
                        "lng": -73.96229110893742,
                        "labeledLatLngs": [{
                            "label": "display",
                            "lat": 40.70995790682886,
                            "lng": -73.96229110893742
                        }],
                        "postalCode": "11211",
                        "cc": "US",
                        "neighborhood": "Williamsburg",
                        "city": "Brooklyn",
                        "state": "NY",
                        "country": "United States",
                        "formattedAddress": [
                            "178 Broadway (at Driggs Ave)",
                            "Brooklyn, NY 11211",
                            "United States"
                        ]
                    },
                    "canonicalUrl": "https://foursquare.com/v/peter-luger-steak-house/3fd66200f964a5209beb1ee3",
                    "categories": [{
                            "id": "4bf58dd8d48988d1cc941735",
                            "name": "Steakhouse",
                            "pluralName": "Steakhouses",
                            "shortName": "Steakhouse",
                            "icon": {
                                "prefix": "https://ss3.4sqi.net/img/categories_v2/food/steakhouse_",
                                "suffix": ".png"
                            },
                            "primary": true
                        },
                        {
                            "id": "4bf58dd8d48988d14e941735",
                            "name": "American Restaurant",
                            "pluralName": "American Restaurants",
                            "shortName": "American",
                            "icon": {
                                "prefix": "https://ss3.4sqi.net/img/categories_v2/food/default_",
                                "suffix": ".png"
                            }
                        }
                    ],
                    "verified": true,
                    "stats": {
                        "tipCount": 679
                    },
                    "url": "http://peterluger.com",
                    "price": {
                        "tier": 4,
                        "message": "Very Expensive",
                        "currency": "$"
                    },
                    "hasMenu": true,
                    "likes": {
                        "count": 1931,
                        "groups": [{
                            "type": "others",
                            "count": 1931,
                            "items": []
                        }],
                        "summary": "1931 Likes"
                    },
                    "dislike": false,
                    "ok": false,
                    "rating": 8.8,
                    "ratingColor": "73CF42",
                    "ratingSignals": 2658,
                    "menu": {
                        "type": "Menu",
                        "label": "Menu",
                        "anchor": "View Menu",
                        "url": "https://foursquare.com/v/peter-luger-steak-house/3fd66200f964a5209beb1ee3/menu",
                        "mobileUrl": "https://foursquare.com/v/3fd66200f964a5209beb1ee3/device_menu"
                    },
                    "allowMenuUrlEdit": true,
                    "beenHere": {
                        "count": 0,
                        "unconfirmedCount": 0,
                        "marked": false,
                        "lastCheckinExpiredAt": 0
                    },
                    "specials": {
                        "count": 0,
                        "items": []
                    },
                    "photos": {
                        "count": 3116,
                        "groups": [{
                            "type": "venue",
                            "name": "Venue photos",
                            "count": 3116,
                            "items": [{
                                "id": "56746c1e498e4c310a4258e6",
                                "createdAt": 1450470430,
                                "source": {
                                    "name": "Foursquare Web",
                                    "url": "https://foursquare.com"
                                },
                                "prefix": "https://fastly.4sqi.net/img/general/",
                                "suffix": "/87447937_J9VdinKoIREPNY89gugWIXFuTcA59G97Zpb4LmWeowA.jpg",
                                "width": 552,
                                "height": 376,
                                "user": {
                                    "id": "87447937",
                                    "firstName": "PureWow",
                                    "photo": {
                                        "prefix": "https://fastly.4sqi.net/img/user/",
                                        "suffix": "/87447937-J0LUNLSTPTSQSM5R.png"
                                    },
                                    "type": "page"
                                },
                                "visibility": "public"
                            }]
                        }]
                    }
                }
            }
        }
        """.data(using: .utf8)!
        
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
        
        let expectedName = "Peter Luger Steak House"
        
        do {
            let photoData = try JSONDecoder().decode(FourSquarePhoto.self, from: jsonData)
            let supName = photoData.response.venue.name
            XCTAssertEqual(expectedName, supName)
        } catch {
            XCTFail("decoding error: \(error)")
        }
    }
}
