//
//  HomeViewModel.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 17/03/22.
//

import Foundation

class HomeViewModel: AlamoServiceProtocol {
    var weatherData = HomeWeatherDataModel()
    
    func fetchWeather(for loc: Location = Constants.fallBackLocation(), completion: ((Bool) -> Void)? = nil) {
        request(for: HomeWeatherDataModel.self, with: .dataUrl(lac: loc)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.weatherData = data
                completion?(true)
            case .failure:
                completion?(false)
            }
        }
    }
}
