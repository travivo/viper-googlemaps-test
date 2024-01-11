//
//  MapInteractor.swift
//  directions
//
//  Created by aljon antiola on 11/18/23.
//

import UIKit
import CoreLocation
import Foundation
import Alamofire
import SwiftyJSON

protocol MapInteractorProtocol {
    var presenter: MapPresenterProtocol? { get set }
    
    func loadDirection(from sourceCoord: CLLocationCoordinate2D, to destinationCoord: CLLocationCoordinate2D, completionHandler: @escaping (_ routes: [JSON]?, _ error: Error?) -> ())
}

class MapInteractor: MapInteractorProtocol {
    
    var presenter: MapPresenterProtocol?
    
    func loadDirection(from sourceCoord: CLLocationCoordinate2D, to destinationCoord: CLLocationCoordinate2D, completionHandler: @escaping (_ routes: [JSON]?, _ error: Error?) -> ()) {
        
        let parameters = ["origin": "\(sourceCoord.latitude)," + "\(sourceCoord.longitude)", "destination": "\(destinationCoord.latitude)," + "\(destinationCoord.longitude)", "key":K.API.GMSServicesKey]
        
        AF.request(K.API.directionUrl(), parameters: parameters).response { response in
            guard let data = response.data else {
                return
            }
            
            do {
                let json = try JSON(data: data)
                let routes = json["routes"].arrayValue
                completionHandler(routes, nil)
            }
            
            catch let error {
                completionHandler(nil, error)
                print(error.localizedDescription)
            }
        }
    }
}
    
