//
//  HomeLandingVC.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 15/03/22.
//

import UIKit
import CoreLocation

//MARK: - HomeLandingVC
class HomeLandingVC: BaseViewController {
    
    
    //MARK: - IBOutets
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var airPressureLabel: UILabel!
    @IBOutlet weak var humudityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var midStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    //MARK: - Properties
    fileprivate var homeVM = HomeViewModel()
    fileprivate var locationManager = CLLocationManager()

    var newLocation: Location?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchData(skipLocationRequest: newLocation != nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Add code here
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Add code here
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Add code here

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Add code here
    }
    
    //MARK: - IBActions
    @IBAction func searchButtonAction() {
        
    }
    
    @IBAction func locationButtonAction() {
        setupLocation()
    }
    
    
    
    //MARK: - Methods
    private func setupUI() {
        searchButton.isHidden = newLocation != nil
        locationButton.isHidden = newLocation != nil
    }
    
    //MARK: Location handling
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestLocation()

        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            guard CLLocationManager.locationServicesEnabled() else {
                fetchData()
                return
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            openPermissionAlert()
            
        @unknown default:
            //Add code here
            break
        }
    }

    //MARK: Data fetching
    fileprivate func fetchData(skipLocationRequest: Bool = false) {
        setupInitialData()
        guard isLocationAvailable() || skipLocationRequest else {
            setupLocation()
            return
        }
        homeVM.fetchWeather() { [weak self] success in
            if success {
                self?.setupData()
            } else {
                // Failed to fetch data
            }
        }
    }
    
    private func setupInitialData() {
        timeLabel.text = "Fetching..."
        temperatureLabel.isHidden = true
        imageContainerView.isHidden = true
        weatherLabel.isHidden = true
        airPressureLabel.isHidden = true
        humudityLabel.isHidden = true
        visibilityLabel.isHidden = true
        if let newLocation = newLocation {
            homeVM.currentLocation = newLocation
        }
    }
    
    //MARK: Data handling
    private func setupData() {
        weatherLabel.text = homeVM.weatherData.weather.first?.main ?? ""
        temperatureLabel.text = " \(homeVM.weatherData.mainData.temperature)°"
        airPressureLabel.text = "\(homeVM.weatherData.mainData.pressure) mBar"
        humudityLabel.text = "\(homeVM.weatherData.mainData.humidity)%"
        visibilityLabel.text = "\(homeVM.weatherData.visibility/1000) KM"
        
        let date = NSDate(timeIntervalSince1970: homeVM.weatherData.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: date as Date)
        timeLabel.text = homeVM.weatherData.name + " (upadated at " + dateString + ")"
        
        if let icon = homeVM.weatherData.weather.first?.icon {
            weatherIconImageView.setImage(with: NetworkConstants.imageUrl(icon: icon).getUrl())
        }
        
        imageContainerView.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut]) {
            self.temperatureLabel.isHidden = false
            self.weatherLabel.isHidden = false
            self.imageContainerView.isHidden = false
            self.airPressureLabel.isHidden = false
            self.humudityLabel.isHidden = false
            self.visibilityLabel.isHidden = false
            self.imageContainerView.alpha = 1
            self.midStackView.layoutIfNeeded()
            self.bottomStackView.layoutIfNeeded()
        }
    }
    
    private func openPermissionAlert() {
        let alertController = UIAlertController(title: "TITLE", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            self.fetchData(skipLocationRequest: true)
        }))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else { return }
            UIApplication.shared.open(settingsUrl)
        })
        self.present(alertController, animated: true)
    }
    
    private func isLocationAvailable() -> Bool {
        return homeVM.currentLocation != Constants.fallBackLocation()
    }
}

//MARK: - HomeLandingVC Extension
extension HomeLandingVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first  else { return }
        homeVM.currentLocation = (location.coordinate.latitude, location.coordinate.longitude)
        fetchData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        fetchData()
    }
}
