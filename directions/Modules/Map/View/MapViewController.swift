//
//  MapViewController.swift
//  directions
//
//  Created by aljon antiola on 11/18/23.
//

import GoogleMaps
import CoreLocation
import SwiftyJSON
import UIKit

protocol MapViewControllerProtocol {
    var presenter: MapPresenterProtocol? { get set }
    func initialSetup()
    func setUpCurrentLocation(with location: CLLocation)
    func drawDirectionPath(with routes: [JSON]?)
    func setNavigationTitle(with title: String)
}

class MapViewController: UIViewController, GMSMapViewDelegate {
    var presenter: MapPresenterProtocol?
    var selectedLocation: Location?
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var likelyPlaces:[Any] = []
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mapContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
    
    @IBAction func doneButonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


// MARK: MapViewControllerProtocol

extension MapViewController: MapViewControllerProtocol {
    
    func initialSetup() {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: (selectedLocation?.getCLLocDegreesLat())!, longitude: (selectedLocation?.getCLLocDegreesLong())!, zoom: 12)
        options.frame = self.mapContainerView.bounds
        mapView = GMSMapView(options:options)
        
        let marker = GMSMarker()
        marker.title = selectedLocation?.name
        marker.position = CLLocationCoordinate2D(latitude: (selectedLocation?.getCLLocDegreesLat())!, longitude: (selectedLocation?.getCLLocDegreesLong())!)
        marker.map = mapView
        
        self.mapContainerView.addSubview(mapView)
        setUpLocationManager()
    }
    
    func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
    }
    
    
    func setUpCurrentLocation(with location: CLLocation) {
        let sourceLoc = location.coordinate
        let destinationLoc = CLLocationCoordinate2D(latitude: (selectedLocation?.getCLLocDegreesLat())!, longitude: (selectedLocation?.getCLLocDegreesLong())!)
        let mapBounds = GMSCoordinateBounds(coordinate: sourceLoc, coordinate: destinationLoc)
        let cameraWithPadding: GMSCameraUpdate = GMSCameraUpdate.fit(mapBounds, withPadding: 100.0)
        
        mapView.animate(with: cameraWithPadding)
        
        let marker = GMSMarker()
        marker.title = "You are here"
        marker.layer.backgroundColor = UIColor.systemBlue.cgColor
        marker.position = CLLocationCoordinate2D(latitude: sourceLoc.latitude, longitude: sourceLoc.longitude)
        marker.map = mapView
        
        presenter?.loadDirection(with: sourceLoc, destinationLoc: destinationLoc)
    }
    
    func setNavigationTitle(with title: String) {
        self.navigationBar.topItem?.title = title
    }
    
    func drawDirectionPath(with routes: [SwiftyJSON.JSON]?) {
        guard let routes = routes else { return }
        
        for route in routes {
            let overview_polyline = route["overview_polyline"].dictionary
            let points = overview_polyline?["points"]?.string
            let path = GMSPath.init(fromEncodedPath: points ?? "")
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = .systemBlue
            polyline.strokeWidth = 5.0
            polyline.map = mapView
            
            let legs = route["legs"].arrayValue
            for leg in legs {
                let distance = leg["distance"].dictionary
                let distanceText = distance?["text"]?.string
                setNavigationTitle(with: (selectedLocation?.name ?? "Distance") + ": " + (distanceText ?? "0 km"))
            }
        }
    }
}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        presenter?.didLoadCurrentLocation(with: location)
        manager.stopUpdatingLocation()
    }
    
    // Handle authorization for the location manager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        presenter?.locationManager(manager, didChangeAuthorization: status)
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error here: \(error)")
    }
    
}
