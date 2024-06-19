//
//  RastaurantMapViewController.swift
//  SearchRestaurant
//
//  Created by 강석호 on 6/19/24.
//

import UIKit
import SnapKit
import CoreLocation
import MapKit

class RastaurantMapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let mapView = MKMapView()
    let restaurantList = RestaurantList().restaurantArray
    let locationButton = UIButton()
    var filteredRestaurantList = [Restaurant]()
    let categories = ["전체"] + Array(Set(RestaurantList().restaurantArray.map { $0.category }))
    
    lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        checkDeviceLocationAuthorization()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "맛집지도"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        view.addSubview(mapView)
        view.addSubview(locationButton)
        view.addSubview(filterCollectionView)
        
        locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        locationButton.backgroundColor = .white
        locationButton.layer.cornerRadius = 20
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        locationButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(mapView).inset(10)
            make.width.height.equalTo(40)
        }
        filterCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
    
    @objc func locationButtonTapped() {
        checkDeviceLocationAuthorization()
    }
}

extension RastaurantMapViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        cell.configure(with: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.item]
        if selectedCategory == "전체" {
            showAllRestaurants()
        } else {
            filterRestaurants(by: selectedCategory)
        }
    }
    
    func filterRestaurants(by category: String) {
        filteredRestaurantList = restaurantList.filter { $0.category == category }
        mapView.removeAnnotations(mapView.annotations)
        addAnnotations(for: filteredRestaurantList)
    }
    
    func showAllRestaurants() {
        mapView.removeAnnotations(mapView.annotations)
        addAnnotations(for: restaurantList)
    }
}

extension RastaurantMapViewController {
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let auth: CLAuthorizationStatus
                if #available(iOS 14.0, *) {
                    auth = self.locationManager.authorizationStatus
                } else {
                    auth = CLLocationManager.authorizationStatus()
                }
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: auth)
                }
            } else {
                print("위치 서비스 꺼짐")
            }
        }
    }
    
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            showLocationSettingAlert()
            setRegionToDefaultLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            addAnnotations(for: restaurantList)
        default:
            print(status)
        }
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        print(region)
        mapView.setRegion(region, animated: true)
    }
    
    func setRegionToDefaultLocation() {
        let defaultCenter = CLLocationCoordinate2D(latitude: 37.51796776198941, longitude: 126.88659213408837)
        setRegionAndAnnotation(center: defaultCenter)
        addAnnotations(for: restaurantList)
    }
    
    func showLocationSettingAlert() {
        let alert = UIAlertController(title: "위치 권한 필요함", message: "설정에서 위치 권한을 허용해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func addAnnotations(for restaurants: [Restaurant]) {
        for restaurant in restaurants {
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            mapView.addAnnotation(annotation)
        }
    }
}

extension RastaurantMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print(locations)
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
            print(coordinate.latitude)
            print(coordinate.longitude)
            setRegionAndAnnotation(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "iOS14+")
        checkDeviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function, "iOS14-")
    }
}
