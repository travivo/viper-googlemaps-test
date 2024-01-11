//
//  MapRouter.swift
//  directions
//
//  Created by aljon antiola on 11/18/23.
//

import UIKit
import Foundation

typealias MapEntryPoint = MapViewControllerProtocol & MapViewController

protocol MapRouterProtocol {
    var entry: MapEntryPoint? { get }
    static func start() -> MapRouterProtocol
}

class MapRouter: MapRouterProtocol {
    var entry: MapEntryPoint?
    
    static func start() -> MapRouterProtocol {
        let router = MapRouter()
        
        // Assign view, interactor and presenter here
        var view: MapViewControllerProtocol = MapViewController()
        var presenter: MapPresenterProtocol = MapPresenter()
        var interactor: MapInteractorProtocol = MapInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? MapEntryPoint
        return router
    }
    
    
}
