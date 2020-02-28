//
//  CoreLocationSession.swift
//  Mock-Foursquare-App
//
//  Created by Gregory Keeley on 2/26/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit
import MapKit

class CoreLocationSession: NSObject {
  
  public var locationManager: CLLocationManager
  
  override init() {
    locationManager = CLLocationManager()
    super.init()
    locationManager.delegate = self
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

//  private func startMonitoringRegion() {
//    let identifier = "monitoring region"
//    let region = CLCircularRegion(center: location.coordinate, radius: 500, identifier: identifier)
//    region.notifyOnEntry = true
//    region.notifyOnExit = false
//    locationManager.startMonitoring(for: region)
//  }
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
