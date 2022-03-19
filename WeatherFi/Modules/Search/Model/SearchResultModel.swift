//
//  SearchResultModel.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 19/03/22.
//

import Foundation

struct SearchResultDataModel: Decodable {
    let name: String
    let latitude: Double
    let longitude: Double
    let state: String
    
    private enum CodingKeys: String, CodingKey {
        case name, state
        case latitude = "lat"
        case longitude = "lon"
    }
}
