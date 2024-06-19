//
//  ViewController.swift
//  SearchRestaurant
//
//  Created by 강석호 on 6/19/24.
//

import UIKit

class RestaurantListViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    var list = RestaurantList().restaurantArray
    var filteredList: [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 140
        filteredList = list
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "맛집리스트"
        view.addSubview(searchBar)
        view.addSubview(tableView)
        tableView.register(RestaurantListTableViewCell.self, forCellReuseIdentifier: "RestaurantListTableViewCell")
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension RestaurantListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            filteredList = list
            tableView.reloadData()
            return
        }
        filteredList = list.filter { $0.name.contains(searchText) }
        tableView.reloadData()
    }
}

extension RestaurantListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantListTableViewCell", for: indexPath) as? RestaurantListTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredList[indexPath.row])
        cell.backgroundColor = .white
        return cell
    }
}
