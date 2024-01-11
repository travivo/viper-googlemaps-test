//
//  DirectoryInteractor.swift
//  directions
//
//  Created by aljon antiola on 11/18/23.
//

import Foundation

// Object
// Protocol
// Ref to presenter

protocol DirectoryInteractorProtocol {
    var presenter: DirectoryPresenterProtocol? { get set }
    
    func getDirectory()
}

class DirectoryInteractor: DirectoryInteractorProtocol {
    var presenter: DirectoryPresenterProtocol?
    
    func getDirectory() {
        self.presenter?.interactorDidFetchDirectory(with: .success(getDefaultDirectory()))
    }
    
    func getDefaultDirectory() -> [Location] {
        var locations = [Location]()
        
        var location1 = Location()
        location1.name = "Tagaytay"
        location1.lat = 14.1172832
        location1.long = 120.8865308
        
        var location2 = Location()
        location2.name = "Baguio"
        location2.lat = 16.3994238
        location2.long = 120.4411206
        
        var location3 = Location()
        location3.name = "Metro Manila"
        location3.lat = 14.5964947
        location3.long = 120.9383599
        
        locations.append(location1)
        locations.append(location2)
        locations.append(location3)
        
        return locations
    }
}
