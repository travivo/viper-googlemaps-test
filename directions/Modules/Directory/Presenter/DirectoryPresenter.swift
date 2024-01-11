//
//  DirectoryPresenter.swift
//  directions
//
//  Created by aljon antiola on 11/18/23.
//

import UIKit
import Foundation

// Object
// Protocol
// Ref to interactor, router, view

protocol DirectoryPresenterProtocol {
    var router: DirectoryRouterProtocol? { get set }
    var interactor: DirectoryInteractorProtocol? { get set }
    var view: DirectoryViewControllerProtocol? { get set }
    
    func interactorDidFetchDirectory(with result: Result<[Location], Error>)
    func didSelectLocation(with location: Location, from view: UIViewController)
}

class DirectoryPresenter: DirectoryPresenterProtocol {
    var router: DirectoryRouterProtocol?
    var interactor: DirectoryInteractorProtocol? {
        didSet {
            interactor?.getDirectory()
        }
    }
    var view: DirectoryViewControllerProtocol?
    
    func interactorDidFetchDirectory(with result: Result<[Location], Error>) {
        switch result {
        case .success(let locations):
            view?.update(with: locations)
        case .failure(_):
            // ???
            break
        }
    }
    
    func didSelectLocation(with location: Location, from view: UIViewController) {
        router?.pushToMapViewController(with: location, from: view)
    }
}
