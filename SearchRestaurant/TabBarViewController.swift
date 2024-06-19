//
//  TabBarViewController.swift
//  SearchRestaurant
//
//  Created by 강석호 on 6/19/24.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .red
        tabBar.unselectedItemTintColor = .gray
        
        let allRestaurant = RestaurantListViewController()
        let nav1 = UINavigationController(rootViewController: allRestaurant)
        nav1.tabBarItem = UITabBarItem(title: "맛집리스트", image: UIImage(systemName: "house"), tag: 0)
        
        let map = RastaurantMapViewController()
        let nav2 = UINavigationController(rootViewController: map)
        nav2.tabBarItem = UITabBarItem(title: "맛집지도", image: UIImage(systemName: "map"), tag: 1)
        
        setViewControllers([nav1,nav2], animated: true)
    }
}
