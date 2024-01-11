//
//  Location.swift
//  directions
//
//  Created by aljon antiola on 11/10/23.
//

import CoreLocation
import Foundation

struct Location: Codable {
    var name: String?
    var lat: Double?
    var long: Double?
    
    func getCLLocDegreesLat() -> CLLocationDegrees {
        return CLLocationSpeed(floatLiteral: lat ?? 0.0)
    }
    
    func getCLLocDegreesLong() -> CLLocationDegrees {
        return CLLocationSpeed(floatLiteral: long ?? 0.0)
    }
}
