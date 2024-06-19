//
// RastaurantMapViewController.swift
// SearchRestaurant
//
// Created by 강석호 on 6/19/24.
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
    let filterCollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        checkDeviceLocationAuthorization()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "맛집지도"
        
        view.addSubview(mapView)
        view.addSubview(locationButton)
        
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
    }
    
    func addAnnotations() {
        for restaurant in restaurantList {
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            mapView.addAnnotation(annotation)
        }
    }
    
    @objc func locationButtonTapped() {
        checkDeviceLocationAuthorization()
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
            addAnnotations()
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
        addAnnotations()
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
