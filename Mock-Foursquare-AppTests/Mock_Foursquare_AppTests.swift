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
                "requestId": "5e5815279388d7001b75ced4"
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
                        "labeledLatLngs": [
                            {
                                "label": "display",
                                "lat": 40.70995790682886,
                                "lng": -73.96229110893742
                            }
                        ],
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
                    "categories": [
                        {
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
                        "groups": [
                            {
                                "type": "others",
                                "count": 1931,
                                "items": []
                            }
                        ],
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
                        "groups": [
                            {
                                "type": "venue",
                                "name": "Venue photos",
                                "count": 3116,
                                "items": [
                                    {
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
                                    }
                                ]
                            }
                        ]
                    },
                    "venuePage": {
                        "id": "77462637"
                    },
                    "reasons": {
                        "count": 1,
                        "items": [
                            {
                                "summary": "Lots of people like this place",
                                "type": "general",
                                "reasonName": "rawLikesReason"
                            }
                        ]
                    },
                    "description": "Peter Luger Steak House has been serving the finest steaks since 1887. We choose from only the finest USDA PRIME meat available. The selection process is crucial  and therefore is done only by members of the family who visit the wholesale markets on a daily basis.",
                    "page": {
                        "user": {
                            "id": "77462637",
                            "firstName": "Peter Luger Steak House",
                            "photo": {
                                "prefix": "https://fastly.4sqi.net/img/user/",
                                "suffix": "/77462637-RJ0SQU0KIYBHRTXZ.png"
                            },
                            "type": "venuePage",
                            "venue": {
                                "id": "3fd66200f964a5209beb1ee3"
                            },
                            "tips": {
                                "count": 0
                            },
                            "lists": {
                                "groups": [
                                    {
                                        "type": "created",
                                        "count": 2,
                                        "items": []
                                    }
                                ]
                            },
                            "bio": ""
                        }
                    },
                    "hereNow": {
                        "count": 0,
                        "summary": "Nobody here",
                        "groups": []
                    },
                    "createdAt": 1071014400,
                    "tips": {
                        "count": 679,
                        "groups": [
                            {
                                "type": "others",
                                "name": "All tips",
                                "count": 679,
                                "items": [
                                    {
                                        "id": "510bc12be4b04c8c993472c6",
                                        "createdAt": 1359724843,
                                        "text": "Girls happened here. Jessa meets Thomas-John's parents at this steakhouse and regales the group with tales of her rehab-attending past.",
                                        "type": "user",
                                        "canonicalUrl": "https://foursquare.com/item/510bc12be4b04c8c993472c6",
                                        "lang": "en",
                                        "likes": {
                                            "count": 45,
                                            "groups": [
                                                {
                                                    "type": "others",
                                                    "count": 45,
                                                    "items": []
                                                }
                                            ],
                                            "summary": "45 likes"
                                        },
                                        "logView": true,
                                        "agreeCount": 45,
                                        "disagreeCount": 0,
                                        "todo": {
                                            "count": 7
                                        },
                                        "user": {
                                            "id": "13225115",
                                            "firstName": "HBO",
                                            "photo": {
                                                "prefix": "https://fastly.4sqi.net/img/user/",
                                                "suffix": "/13225115-AJZONGJHWAEFMLYE.jpg"
                                            },
                                            "type": "page"
                                        }
                                    }
                                ]
                            }
                        ]
                    },
                    "shortUrl": "http://4sq.com/4syDel",
                    "timeZone": "America/New_York",
                    "listed": {
                        "count": 4379,
                        "groups": [
                            {
                                "type": "others",
                                "name": "Lists from other people",
                                "count": 4379,
                                "items": [
                                    {
                                        "id": "560d746d498eb89dd0264ed8",
                                        "name": "NYC's 2016 Michelin-Starred Restaurants",
                                        "description": "The results are in for this year's Michelin stars. Newer spots gained recognition along with the classic NYC establishments that continue to shine. Here is the full list of top-notch restaurants.",
                                        "type": "others",
                                        "user": {
                                            "id": "23438729",
                                            "firstName": "Foursquare City Guide",
                                            "photo": {
                                                "prefix": "https://fastly.4sqi.net/img/user/",
                                                "suffix": "/23438729-TODURDIUDUMY4JF5.png"
                                            },
                                            "type": "page"
                                        },
                                        "editable": false,
                                        "public": true,
                                        "collaborative": false,
                                        "url": "/foursquare/list/nycs-2016-michelinstarred-restaurants",
                                        "canonicalUrl": "https://foursquare.com/foursquare/list/nycs-2016-michelinstarred-restaurants",
                                        "createdAt": 1443722349,
                                        "updatedAt": 1509051620,
                                        "photo": {
                                            "id": "54f949c1498e91d4c02f5f39",
                                            "createdAt": 1425623489,
                                            "prefix": "https://fastly.4sqi.net/img/general/",
                                            "suffix": "/13152975_IjDJlZf1ckcQepnaBYQbCJ4qc2utlMGcYDbvHOkEVLU.jpg",
                                            "width": 1477,
                                            "height": 1440,
                                            "user": {
                                                "id": "13152975",
                                                "firstName": "ArtJonak",
                                                "photo": {
                                                    "prefix": "https://fastly.4sqi.net/img/user/",
                                                    "suffix": "/BDCTN0QSGNHOOM0K.jpg"
                                                }
                                            },
                                            "visibility": "public"
                                        },
                                        "logView": true,
                                        "guideType": "bestOf",
                                        "guide": true,
                                        "followers": {
                                            "count": 1354
                                        },
                                        "listItems": {
                                            "count": 74,
                                            "items": [
                                                {
                                                    "id": "t55b3ef52498e9b90bdc41bbc",
                                                    "createdAt": 1443728765,
                                                    "photo": {
                                                        "id": "55e288e2498eeeede35bb9f5",
                                                        "createdAt": 1440909538,
                                                        "prefix": "https://fastly.4sqi.net/img/general/",
                                                        "suffix": "/120058_Jz-In4t5E-eS-cCRx9IOs1NNU1ieTmcbUviB0UcML4g.jpg",
                                                        "width": 1920,
                                                        "height": 1440,
                                                        "user": {
                                                            "id": "120058",
                                                            "firstName": "Jason",
                                                            "lastName": "W",
                                                            "photo": {
                                                                "prefix": "https://fastly.4sqi.net/img/user/",
                                                                "suffix": "/2VYW2HGKN4ZMIBVV.jpg"
                                                            }
                                                        },
                                                        "visibility": "public"
                                                    }
                                                }
                                            ]
                                        }
                                    },
                                    {
                                        "id": "54c9597c498e50bd18a9d63a",
                                        "name": "The Tastes that Make the City: New York Edition",
                                        "description": "From the pastrami sandwich at Katz's to Balthazar's pomme frites, there are some dishes that are classic NYC. Foursquare's data scientists identified the top 50, and we challenge you to try them all.",
                                        "type": "others",
                                        "user": {
                                            "id": "107525669",
                                            "firstName": "The Tastes that Make the City",
                                            "photo": {
                                                "prefix": "https://fastly.4sqi.net/img/user/",
                                                "suffix": "/107525669-2335RXPTBZGTCH32"
                                            }
                                        },
                                        "editable": false,
                                        "public": true,
                                        "collaborative": false,
                                        "url": "/citytastes/list/the-tastes-that-make-the-city-new-york-edition",
                                        "canonicalUrl": "https://foursquare.com/citytastes/list/the-tastes-that-make-the-city-new-york-edition",
                                        "createdAt": 1422481788,
                                        "updatedAt": 1435256661,
                                        "photo": {
                                            "id": "5568808c498eda92ec60e893",
                                            "createdAt": 1432912012,
                                            "prefix": "https://fastly.4sqi.net/img/general/",
                                            "suffix": "/107525669_evsnhV04T8wpsz1MLCMupb3OwANaIIhLLeqKGkGLZU4.jpg",
                                            "width": 720,
                                            "height": 960,
                                            "user": {
                                                "id": "107525669",
                                                "firstName": "The Tastes that Make the City",
                                                "photo": {
                                                    "prefix": "https://fastly.4sqi.net/img/user/",
                                                    "suffix": "/107525669-2335RXPTBZGTCH32"
                                                }
                                            },
                                            "visibility": "public"
                                        },
                                        "readMoreUrl": "https://foursquare.com/top-places/new-york-city/tastes-that-make-the-city",
                                        "guideType": "bestOf",
                                        "guide": true,
                                        "followers": {
                                            "count": 2760
                                        },
                                        "listItems": {
                                            "count": 50,
                                            "items": [
                                                {
                                                    "id": "t54c95979498e01d155e613e8",
                                                    "createdAt": 1422481794,
                                                    "photo": {
                                                        "id": "5568859c498eda92ec624f51",
                                                        "createdAt": 1432913308,
                                                        "prefix": "https://fastly.4sqi.net/img/general/",
                                                        "suffix": "/107525669_iySQSaV9kEHrehOkYEFQsE22Qmw71o0YaTMV2cajv3g.jpg",
                                                        "width": 960,
                                                        "height": 960,
                                                        "user": {
                                                            "id": "107525669",
                                                            "firstName": "The Tastes that Make the City",
                                                            "photo": {
                                                                "prefix": "https://fastly.4sqi.net/img/user/",
                                                                "suffix": "/107525669-2335RXPTBZGTCH32"
                                                            }
                                                        },
                                                        "visibility": "public"
                                                    }
                                                }
                                            ]
                                        }
                                    },
                                    {
                                        "id": "4e2df6f13151250387b53f5c",
                                        "name": "The 38 Essential New York Restaurants, Winter 2017",
                                        "description": "This highly elite group covers the entire city, spans myriad cuisines, and collectively satisfies all of your restaurant needs, save for those occasions when you absolutely must spend half a paycheck.",
                                        "type": "others",
                                        "user": {
                                            "id": "3343327",
                                            "firstName": "Eater",
                                            "photo": {
                                                "prefix": "https://fastly.4sqi.net/img/user/",
                                                "suffix": "/3343327-YQ1D52V3KK2RQLBU.png"
                                            },
                                            "type": "page"
                                        },
                                        "editable": false,
                                        "public": true,
                                        "collaborative": false,
                                        "url": "/p/eater/3343327/list/the-38-essential-new-york-restaurants-winter-2017",
                                        "canonicalUrl": "https://foursquare.com/p/eater/3343327/list/the-38-essential-new-york-restaurants-winter-2017",
                                        "createdAt": 1311635185,
                                        "updatedAt": 1484851385,
                                        "photo": {
                                            "id": "55490a63498e64abc166eb13",
                                            "createdAt": 1430850147,
                                            "prefix": "https://fastly.4sqi.net/img/general/",
                                            "suffix": "/3343327_KqrI41-ij_diYuWv4rYIR1y6P_0S6tFToA0HanEM6h8.jpg",
                                            "width": 2048,
                                            "height": 1363,
                                            "user": {
                                                "id": "3343327",
                                                "firstName": "Eater",
                                                "photo": {
                                                    "prefix": "https://fastly.4sqi.net/img/user/",
                                                    "suffix": "/3343327-YQ1D52V3KK2RQLBU.png"
                                                },
                                                "type": "page"
                                            },
                                            "visibility": "public"
                                        },
                                        "logView": true,
                                        "readMoreUrl": "http://ny.eater.com/maps/best-new-york-restaurants-38",
                                        "guideType": "bestOf",
                                        "guide": true,
                                        "followers": {
                                            "count": 6873
                                        },
                                        "listItems": {
                                            "count": 38,
                                            "items": [
                                                {
                                                    "id": "t570568c4498ecadbcaf0d132",
                                                    "createdAt": 1459982833,
                                                    "photo": {
                                                        "id": "57928ae3498e325d9be4f1d7",
                                                        "createdAt": 1469221603,
                                                        "prefix": "https://fastly.4sqi.net/img/general/",
                                                        "suffix": "/3343327__Y_9Ux3Bai4WvgRxZWNbcqr5Q3yfE5UCTabwNZvt_iI.png",
                                                        "width": 481,
                                                        "height": 358,
                                                        "user": {
                                                            "id": "3343327",
                                                            "firstName": "Eater",
                                                            "photo": {
                                                                "prefix": "https://fastly.4sqi.net/img/user/",
                                                                "suffix": "/3343327-YQ1D52V3KK2RQLBU.png"
                                                            },
                                                            "type": "page"
                                                        },
                                                        "visibility": "public"
                                                    }
                                                }
                                            ]
                                        }
                                    },
                                    {
                                        "id": "4f3e715ce4b0abb6d69b61de",
                                        "name": "2013 NYC Michelin Starred Restaurants",
                                        "description": "In the latest edition of the highly anticipated MICHELIN Guide New York City 2013, a record 66 restaurants have been awarded Michelin stars.",
                                        "type": "others",
                                        "user": {
                                            "id": "3358242",
                                            "firstName": "Michelin Travel & Lifestyle",
                                            "photo": {
                                                "prefix": "https://fastly.4sqi.net/img/user/",
                                                "suffix": "/VK0PPDE3V1HU20D5.jpg"
                                            },
                                            "type": "page"
                                        },
                                        "editable": false,
                                        "public": true,
                                        "collaborative": false,
                                        "url": "/michelinguides/list/2013-nyc-michelin-starred-restaurants",
                                        "canonicalUrl": "https://foursquare.com/michelinguides/list/2013-nyc-michelin-starred-restaurants",
                                        "createdAt": 1329492316,
                                        "updatedAt": 1384107446,
                                        "logView": true,
                                        "followers": {
                                            "count": 3758
                                        },
                                        "listItems": {
                                            "count": 66,
                                            "items": [
                                                {
                                                    "id": "v3fd66200f964a5209beb1ee3",
                                                    "createdAt": 1329493205
                                                }
                                            ]
                                        }
                                    }
                                ]
                            }
                        ]
                    },
                    "hours": {
                        "status": "Open until 9:45 PM",
                        "richStatus": {
                            "entities": [],
                            "text": "Open until 9:45 PM"
                        },
                        "isOpen": true,
                        "isLocalHoliday": false,
                        "dayData": [],
                        "timeframes": [
                            {
                                "days": "Mon–Thu",
                                "includesToday": true,
                                "open": [
                                    {
                                        "renderedTime": "11:45 AM–9:45 PM"
                                    }
                                ],
                                "segments": []
                            },
                            {
                                "days": "Fri–Sat",
                                "open": [
                                    {
                                        "renderedTime": "11:45 AM–10:45 PM"
                                    }
                                ],
                                "segments": []
                            },
                            {
                                "days": "Sun",
                                "open": [
                                    {
                                        "renderedTime": "12:45 PM–9:45 PM"
                                    }
                                ],
                                "segments": []
                            }
                        ]
                    },
                    "popular": {
                        "status": "Likely open",
                        "richStatus": {
                            "entities": [],
                            "text": "Likely open"
                        },
                        "isOpen": true,
                        "isLocalHoliday": false,
                        "timeframes": [
                            {
                                "days": "Today",
                                "includesToday": true,
                                "open": [
                                    {
                                        "renderedTime": "Noon–3:00 PM"
                                    },
                                    {
                                        "renderedTime": "5:00 PM–10:00 PM"
                                    }
                                ],
                                "segments": []
                            },
                            {
                                "days": "Fri–Sat",
                                "open": [
                                    {
                                        "renderedTime": "Noon–11:00 PM"
                                    }
                                ],
                                "segments": []
                            },
                            {
                                "days": "Sun",
                                "open": [
                                    {
                                        "renderedTime": "Noon–10:00 PM"
                                    }
                                ],
                                "segments": []
                            },
                            {
                                "days": "Mon",
                                "open": [
                                    {
                                        "renderedTime": "Noon–3:00 PM"
                                    },
                                    {
                                        "renderedTime": "5:00 PM–10:00 PM"
                                    }
                                ],
                                "segments": []
                            },
                            {
                                "days": "Tue–Wed",
                                "open": [
                                    {
                                        "renderedTime": "Noon–2:00 PM"
                                    },
                                    {
                                        "renderedTime": "5:00 PM–10:00 PM"
                                    }
                                ],
                                "segments": []
                            }
                        ]
                    },
                    "pageUpdates": {
                        "count": 0,
                        "items": []
                    },
                    "inbox": {
                        "count": 0,
                        "items": []
                    },
                    "attributes": {
                        "groups": [
                            {
                                "type": "price",
                                "name": "Price",
                                "summary": "$$$$",
                                "count": 1,
                                "items": [
                                    {
                                        "displayName": "Price",
                                        "displayValue": "$$$$",
                                        "priceTier": 4
                                    }
                                ]
                            },
                            {
                                "type": "reservations",
                                "name": "Reservations",
                                "summary": "Reservations",
                                "count": 3,
                                "items": [
                                    {
                                        "displayName": "Reservations",
                                        "displayValue": "Yes"
                                    }
                                ]
                            },
                            {
                                "type": "payments",
                                "name": "Credit Cards",
                                "summary": "No Credit Cards",
                                "count": 7,
                                "items": [
                                    {
                                        "displayName": "Credit Cards",
                                        "displayValue": "No"
                                    }
                                ]
                            },
                            {
                                "type": "outdoorSeating",
                                "name": "Outdoor Seating",
                                "count": 1,
                                "items": [
                                    {
                                        "displayName": "Outdoor Seating",
                                        "displayValue": "No"
                                    }
                                ]
                            },
                            {
                                "type": "privateRoom",
                                "name": "Private Room",
                                "summary": "Private Room",
                                "count": 1,
                                "items": [
                                    {
                                        "displayName": "Private Room",
                                        "displayValue": "Yes"
                                    }
                                ]
                            },
                            {
                                "type": "serves",
                                "name": "Menus",
                                "summary": "Dessert, Brunch & more",
                                "count": 8,
                                "items": [
                                    {
                                        "displayName": "Brunch",
                                        "displayValue": "Brunch"
                                    },
                                    {
                                        "displayName": "Lunch",
                                        "displayValue": "Lunch"
                                    },
                                    {
                                        "displayName": "Dinner",
                                        "displayValue": "Dinner"
                                    },
                                    {
                                        "displayName": "Dessert",
                                        "displayValue": "Dessert"
                                    }
                                ]
                            },
                            {
                                "type": "drinks",
                                "name": "Drinks",
                                "summary": "Beer, Wine, Full Bar & Cocktails",
                                "count": 5,
                                "items": [
                                    {
                                        "displayName": "Beer",
                                        "displayValue": "Beer"
                                    },
                                    {
                                        "displayName": "Wine",
                                        "displayValue": "Wine"
                                    },
                                    {
                                        "displayName": "Full Bar",
                                        "displayValue": "Full Bar"
                                    },
                                    {
                                        "displayName": "Cocktails",
                                        "displayValue": "Cocktails"
                                    }
                                ]
                            },
                            {
                                "type": "diningOptions",
                                "name": "Dining Options",
                                "count": 5,
                                "items": [
                                    {
                                        "displayName": "Delivery",
                                        "displayValue": "No Delivery"
                                    }
                                ]
                            },
                            {
                                "type": "restroom",
                                "name": "Restroom",
                                "summary": "Restroom",
                                "count": 1,
                                "items": [
                                    {
                                        "displayName": "Restroom",
                                        "displayValue": "Yes"
                                    }
                                ]
                            }
                        ]
                    },
                    "bestPhoto": {
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
                        "visibility": "public"
                    },
                    "colors": {
                        "highlightColor": {
                            "photoId": "56746c1e498e4c310a4258e6",
                            "value": -2039608
                        },
                        "highlightTextColor": {
                            "photoId": "56746c1e498e4c310a4258e6",
                            "value": -16777216
                        },
                        "algoVersion": 3
                    }
                }
            }
        }
        """.data(using: .utf8)!
        
        struct VenueDetail: Codable & Equatable {
            let response: Response
        }
        struct Response: Codable & Equatable {
            let venue: ResponseVenue
        }
        struct ResponseVenue: Codable & Equatable {
            let name: String
            let description: String
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
            let venueDetails = try JSONDecoder().decode(VenueDetail.self, from: jsonData)
            let supName = venueDetails.response.venue.name
            XCTAssertEqual(expectedName, supName)
        } catch {
            XCTFail("decoding error: \(error)")
        }
    }
}
