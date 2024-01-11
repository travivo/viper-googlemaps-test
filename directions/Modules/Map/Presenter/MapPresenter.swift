//
//  MapPresenter.swift
//  directions
//
//  Created by aljon antiola on 11/18/23.
//

import CoreLocation
import Foundation

protocol MapPresenterProtocol {
    var router: MapRouterProtocol? { get set }
    var interactor: MapInteractorProtocol? { get set }
    var view: MapViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didLoadDirection(with result:Bool)
    func didLoadCurrentLocation(with location: CLLocation)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    func loadDirection(with sourceLoc: CLLocationCoordinate2D, destinationLoc: CLLocationCoordinate2D)
}

class MapPresenter: MapPresenterProtocol {
    
    var router: MapRouterProtocol?
    var interactor: MapInteractorProtocol?
    var view: MapViewControllerProtocol?
    
    func viewDidLoad() {
        view?.initialSetup()
    }
    
    func didLoadDirection(with result: Bool) {
        switch result {
        case true:
            break
        case false:
            // ???
            break
        }
    }
    
    func didLoadCurrentLocation(with location: CLLocation) {
        view?.setUpCurrentLocation(with: location)
    }
    
    func loadDirection(with sourceLoc: CLLocationCoordinate2D, destinationLoc: CLLocationCoordinate2D) {
        interactor?.loadDirection(from: sourceLoc, to: destinationLoc, completionHandler: { routes, error in
            self.view?.drawDirectionPath(with: routes ?? nil)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        
        // Handle authorization status, call view if necessary
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            manager.startUpdatingLocation()
        @unknown default:
            fatalError()
        }
    }
    
}
