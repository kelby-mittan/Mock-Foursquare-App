//
//  CoreLocationSession.swift
//  Mock-Foursquare-App
//
//  Created by Gregory Keeley on 2/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import MapKit

struct Location {
  let title: String
  let body: String
  let coordinate: CLLocationCoordinate2D
  let imageName: String
  
  static func getLocations() -> [Location] {
    return [
      Location(title: "Pursuit", body: "We train adults with the most need and potential to get hired in tech, advance in their careers, and become the next generation of leaders in tech.", coordinate: CLLocationCoordinate2D(latitude: 40.74296, longitude: -73.94411), imageName: "team-6-3"),
      Location(title: "Brooklyn Museum", body: "The Brooklyn Museum is an art museum located in the New York City borough of Brooklyn. At 560,000 square feet (52,000 m2), the museum is New York City's third largest in physical size and holds an art collection with roughly 1.5 million works", coordinate: CLLocationCoordinate2D(latitude: 40.6712062, longitude: -73.9658193), imageName: "brooklyn-museum"),
      Location(title: "Central Park", body: "Central Park is an urban park in Manhattan, New York City, located between the Upper West Side and the Upper East Side. It is the fifth-largest park in New York City by area, covering 843 acres (3.41 km2). Central Park is the most visited urban park in the United States, with an estimated 37.5–38 million visitors annually, as well as one of the most filmed locations in the world.", coordinate: CLLocationCoordinate2D(latitude: 40.7828647, longitude: -73.9675438), imageName: "central-park")
    ]
  }
}
class CoreLocationSession: NSObject {
  
  public var locationManager: CLLocationManager
  
  override init() {
    locationManager = CLLocationManager()
    super.init()
    locationManager.delegate = self
    
    // request the user's location
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    startSignificantLocationChanges()

  }
  
  private func startSignificantLocationChanges() {
    if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
      return
    }
    locationManager.startMonitoringSignificantLocationChanges()
  }
  
  public func convertCoordinateToPlacemark(coordinate: CLLocationCoordinate2D) {
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
      if let error = error {
        print("reverseGeocodeLocation: \(error)")
      }
      if let firstPlacemark = placemarks?.first {
        print("placemark info: \(firstPlacemark)")
      }
    }
  }
  
    public func convertPlaceNameToCoordinate(addressString: String, completion: @escaping (Result<CLLocationCoordinate2D,Error>) -> ()) {

     CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in
      if let error = error {
       print("geocodeAddressString: \(error)")
       completion(.failure(error))
      }
      if let firstPlacemark = placemarks?.first,
       let location = firstPlacemark.location {
       print("place name coordinate is \(location.coordinate)")
       completion(.success(location.coordinate))
      }
     }
    }

  private func startMonitoringRegion() {
    let location = Location.getLocations()[2] // central park
    let identifier = "monitoring region"
    let region = CLCircularRegion(center: location.coordinate, radius: 500, identifier: identifier)
    region.notifyOnEntry = true
    region.notifyOnExit = false
    locationManager.startMonitoring(for: region)
  }
}
extension CoreLocationSession: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("didUpdateLocations: \(locations)")
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("didFailWithError: \(error)")
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways:
      print("authorizedAlways")
    case .authorizedWhenInUse:
      print("authorizedWhenInUse")
    case .denied:
      print("denied")
    case .notDetermined:
      print("notDetermined")
    case .restricted:
      print("restricted")
    default:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    print("didEnterRegion: \(region)")
  }
  
  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    print("didExitRegion: \(region)")
  }
}
