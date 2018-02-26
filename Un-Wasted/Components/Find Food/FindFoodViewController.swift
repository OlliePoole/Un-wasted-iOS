//
//  FindFoodViewController.swift
//  NoMoreWaste
//
//  Created by Oliver Poole on 24/02/2018.
//  Copyright © 2018 Oliver Poole. All rights reserved.
//

import UIKit

class FindFoodViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var heyUserLabel: UILabel!
    
    private var dataSource = [FoodItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var foodLoadingStateMachine: LoadingStateMachine<FoodItem> = .initial {
        didSet {
            if case let .loaded(items) = foodLoadingStateMachine {
                dataSource = items
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    var viewModel: FindFoodViewModel!
    
    private var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = FindFoodViewModel(outputs: self)
        viewModel.inputs.loadAvailableFood(location: 0, long: 0)
        
        tableView.contentInset.top = -20
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshControlFired(control:)), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        heyUserLabel.text = "HEY \(UserManager.currentUser.name.uppercased())"
    }
    
    @objc private func refreshControlFired(control: UIRefreshControl) {
        viewModel.inputs.loadAvailableFood(location: 0, long: 0)
    }
}

extension FindFoodViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFoodTableViewCell", for: indexPath) as? FindFoodTableViewCell
        
        cell?.configure(foodItem: self.dataSource[indexPath.row])
        
        return cell!
    }
    
}

extension FindFoodViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = FindFoodDetailViewController.initalize()
        detailViewController.foodItem = dataSource[indexPath.row]
        
        self.present(detailViewController, animated: true, completion: nil)
    }
    
}

extension FindFoodViewController: FindFoodViewModelOutputs { }
