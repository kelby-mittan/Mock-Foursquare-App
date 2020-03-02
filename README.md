# Mock-Foursquare-App
Mock Foursquare App using Mapkit and Core Location

# FourSquare Mock App

Search for local venues, based on a location, and save collections of your favorite venues.

## Overview

Whether you want to search locally, or abroad, you can use this app to search for your favorite spots across the world. Once you have found a spot you like, you can check the details, get driving route, or save the venue for future reference.

## Features

* Search for venues locally, or abroad
* Display driving directions route
* See photos from the location, including location details
* Save venues to individual collection for later viewing

## Built With

* Swift 11.3
* MapKit
* [FourSquare API](https://developer.foursquare.com) 

## Code Example

### Creating a route for driving directions, direclty on the map view
```swift
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.removeOverlays(mapView.overlays)
        guard let annotation = view.annotation else {return}
        guard let location = (annotations.filter { $0.subtitle == annotation.subtitle }).first else { return }
        let sourceCoord = mapView.userLocation
        let destinationCoord = location.coordinate
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoord.coordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoord, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = ""
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = annotation.title ?? ""
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        theMapView.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.theMapView.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.theMapView.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            self.theMapView.mapView.setVisibleMapRect(self.theMapView.mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: 60.0, left: 20.0, bottom: 60, right: 20.0), animated: true)
        }
    }
```

## Collaborators

[Kelby Mittan](https://github.com/kelby-mittan)

[Eddie Oneill](https://github.com/Eddieoneill)

[Gregory Keeley](https://github.com/GregKeeley)
