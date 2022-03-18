//
//  NetworkManager.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 16/03/22.
//

import Foundation
import Alamofire


protocol AlamoServiceProtocol {
    func request<T: Decodable>(for: T.Type, with url: NetworkConstants, methodType: HTTPMethod, params: [String: String]?, completion: @escaping (Result<T,Error>) -> Void)
}

extension AlamoServiceProtocol {
    func request<T: Decodable>(for: T.Type, with url: NetworkConstants, methodType: HTTPMethod = .get, params: [String: String]? = nil, completion: @escaping (Result<T,Error>) -> Void) {
        AF.request(url.getUrl(), method: methodType, parameters: params, encoder: .json, headers: nil, interceptor: nil, requestModifier: nil).response { response in
            switch response.result {
            case .success(let data):
                if let model = decodeData(for: T.self, from: data) {
                    completion(.success(model))
                } else {
                    completion(.failure(CustomError.parsingFailed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func decodeData<T: Decodable>(for: T.Type, from data: Data?) -> T? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

enum CustomError: Error {
    case parsingFailed
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .parsingFailed:
            return NSLocalizedString("The provide model could not be parse, please check the issue.", comment: "Something went wrong.")
        }
    }
}
