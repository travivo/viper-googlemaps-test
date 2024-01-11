//
//  DirectoryViewController.swift
//  directions
//
//  Created by aljon antiola on 11/10/23.
//

import UIKit

protocol DirectoryViewControllerProtocol {
    var presenter: DirectoryPresenterProtocol? { get set }
    func update(with locations: [Location])
}

class DirectoryViewController: UIViewController, DirectoryViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {
    
    var presenter: DirectoryPresenterProtocol?
    var locations: [Location] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func update(with locations: [Location]) {
        DispatchQueue.main.async {
            self.locations = locations
            self.tableView.reloadData()
        }
    }
}


extension DirectoryViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        // Configure content.
        content.text = locations[indexPath.row].name
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectLocation(with: locations[indexPath.row], from: self)
    }
}
