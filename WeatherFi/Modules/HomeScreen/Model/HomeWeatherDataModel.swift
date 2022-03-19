//
//  HomeWeatherDataModel.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 17/03/22.
//

import Foundation

struct HomeWeatherDataModel: Decodable {
    let coordinates: Coordinates
    let weather: [Weather]
    let base: String
    let mainData: MainWeatherData
    let visibility: Int
    let date: Double
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case mainData = "main"
        case date = "dt"
        case weather, base, visibility, name
    }
    
    init() {
        coordinates = .init(latitude: Constants.fallBackLocation().latitude, longitude: Constants.fallBackLocation().longitude)
        weather = []
        base = ""
        mainData = .init(temperature: 0, pressure: 0, humidity: 0)
        visibility = 0
        date = 0
        name = ""
    }
}

struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let icon: String
}

struct MainWeatherData: Decodable {
    let temperature: Double
    let pressure: Int
    let humidity: Int
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case pressure, humidity
    }
}

