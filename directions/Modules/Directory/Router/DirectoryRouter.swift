//
//  DirectoryRouter.swift
//  directions
//
//  Created by aljon antiola on 11/18/23.
//

import Foundation
import UIKit

typealias EntryPoint = DirectoryViewControllerProtocol & UIViewController

protocol DirectoryRouterProtocol {
    var entry: EntryPoint? { get }
    static func start() -> DirectoryRouterProtocol
    func pushToMapViewController(with location:Location, from view: UIViewController)
}

class DirectoryRouter: DirectoryRouterProtocol {

    var entry: EntryPoint?
    
    static func start() -> DirectoryRouterProtocol {
        let router = DirectoryRouter()
        
        // Assign view, interactor and presenter here
        var view: DirectoryViewControllerProtocol = DirectoryViewController()
        var presenter: DirectoryPresenterProtocol = DirectoryPresenter()
        var interactor: DirectoryInteractorProtocol = DirectoryInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        return router
    }
    
    func pushToMapViewController(with location: Location, from view: UIViewController) {
        let mapRouter = MapRouter.start()
        let mapVC = mapRouter.entry
        
        mapVC?.selectedLocation = location
        view.present(mapVC!, animated: true)
    }
}
