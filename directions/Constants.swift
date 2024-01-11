//
//  Constants.swift
//  directions
//
//  Created by aljon antiola on 11/19/23.
//

import Foundation

struct K {
    struct API {
        static let GMSServicesKey = "AIzaSyBjLnHbI8_k_ODyOKX7ZzpBZ9Df_qvsO0c"
        
        static let baseURL = "https://maps.googleapis.com/maps/api/"
        static let service = "directions"
        
        static func directionUrl() -> String {
            return API.baseURL + API.service + "/json?"
        }
    }
}
