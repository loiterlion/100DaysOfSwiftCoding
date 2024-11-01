//
//  ViewController.swift
//  Project16 Mapk
//
//  Created by Bruce on 2024/10/31.
//

import Contacts
import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    fileprivate func addAnnotations() {
        // Do any additional setup after loading the view.
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    func mapTypeChoosed(alertAction: UIAlertAction) {
        guard let title = alertAction.title else { return }
        let array = ["standard", "satellite", "hybrid", "satelliteFlyover", "hybridFlyover", "mutedStandard"]
        if let index = array.firstIndex(of: title) {
            mapView.mapType = MKMapType.init(rawValue: UInt(index)) ?? .standard
            navigationItem.rightBarButtonItem?.title = title
        }
    }
    
    @objc func chooseMapType() {
        
        let ac = UIAlertController(title: "Choose a map type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "standard", style: .default, handler: mapTypeChoosed))
        ac.addAction(UIAlertAction(title: "satellite", style: .default, handler: mapTypeChoosed))
        ac.addAction(UIAlertAction(title: "hybrid", style: .default, handler: mapTypeChoosed))
        ac.addAction(UIAlertAction(title: "satelliteFlyover", style: .default, handler: mapTypeChoosed))
        ac.addAction(UIAlertAction(title: "mutedStandard", style: .default, handler: mapTypeChoosed))
        
        present(ac, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addAnnotations()
        
        let searchBBI = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchAddress))
        let chooseMapTypeBBI = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(chooseMapType))
        let addRouteBBI = UIBarButtonItem(title: "Route", style: .plain, target: self, action: #selector(addRoute))
        navigationItem.rightBarButtonItems = [searchBBI, chooseMapTypeBBI, addRouteBBI]
        
        let coords = CLLocationCoordinate2DMake(22.534964,113.922202)
        
        //176 Changxing Rd, Nanshan, Shenzhen, Guangdong Province, China, 518056
        let address = [CNPostalAddressStreetKey: "176 Changxing Rd", CNPostalAddressCityKey: "Shenzhen", CNPostalAddressPostalCodeKey: "518056", CNPostalAddressISOCountryCodeKey: "CN"]
        let place = MKPlacemark(coordinate: coords, addressDictionary: address)

        mapView.addAnnotation(place)
    }
    
    @objc func addRoute() {
        // 1. remember to add Map Entitlement
        // 2. ensure that google map is enabled in local network
        
        let request = MKDirections.Request()
        
        // 台北
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654), addressDictionary: nil))
        
        // 高雄 22.6273， 120.3014
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 22.6273, longitude: 120.3014), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
           guard let unwrappedResponse = response else { return }

           for route in unwrappedResponse.routes {
               self.mapView.addOverlay(route.polyline)
               self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
           }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.orange
            return renderer
        }
    
    @objc func searchAddress() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Shenzhen Music Hall, Shenzhen"
        searchRequest.region = mapView.region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
               print("Error: \(error?.localizedDescription ?? "Unknown error").")
               return
           }

           for item in response.mapItems {
               print(item.phoneNumber ?? "No phone number.")
           }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.markerTintColor = .blue
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        guard let placeName = capital.title else { return }
        
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.title = placeName
            
            let pathString = "https://en.wikipedia.org/wiki/" + placeName
            vc.url = URL(string: pathString)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

