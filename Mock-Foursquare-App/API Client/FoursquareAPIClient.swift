//
//  FoursquareAPIClient.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import Foundation
import NetworkHelper

struct FoursquareAPIClient {
    
    static func getVenues(location: String, search: String, completion: @escaping (Result<[Venue] ,AppError>) -> ()) {
        

        var foursquareEndpoint = "https://api.foursquare.com/v2/venues/search?client_id=\(APIKeys.id)&client_secret=\(APIKeys.secret)&v=20202002&near=\(location)&intent=browse&radius=10000&query=\(search)&limit=2"

        
        foursquareEndpoint = foursquareEndpoint.replacingOccurrences(of: " ", with: "%20")
        
        guard let url = URL(string: foursquareEndpoint) else {
            completion(.failure(.badURL(foursquareEndpoint)))
            return
        }
        
        let request = URLRequest(url: url)

        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let foursquareSearch = try JSONDecoder().decode(FoursquareSearch.self, from: data)
                    let venues = foursquareSearch.response.venues
                    completion(.success(venues))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    static func getVenuePhotos(locationID: String, completion: @escaping (Result<VenueDetail,AppError>) -> ()) {
        let photosEndpoint = "https://api.foursquare.com/v2/venues/\(locationID)?client_id=\(APIKeys.id)&client_secret=\(APIKeys.secret)&v=20200220"
//        photosEndpoint = photosEndpoint.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: photosEndpoint) else {
            completion(.failure(.badURL(photosEndpoint)))
            return
        }
        let request = URLRequest(url: url)

        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let venuePhotos = try JSONDecoder().decode(VenueDetail.self, from: data)
                    completion(.success(venuePhotos))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
