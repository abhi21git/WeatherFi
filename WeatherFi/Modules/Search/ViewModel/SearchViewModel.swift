//
//  SearchViewModel.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 19/03/22.
//

import Foundation

class SearchViewModel: AlamoServiceProtocol {
    var searchData: [SearchResultDataModel] = []
    
    func fetchResults(for query: String, completion: ((Bool) -> Void)? = nil) {
        request(for: [SearchResultDataModel].self, with: .searchLocation(query: query)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.searchData = data
                completion?(true)
            case .failure:
                completion?(false)
            }
        }
    }
}
