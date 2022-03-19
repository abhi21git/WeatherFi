//
//  Constants.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 16/03/22.
//

import UIKit

// MARK: Type alias
typealias Location = (latitude: Double, longitude: Double)

// MARK: App Constants
enum Constants: String {
    case abc = "abc"

    static func fallBackLocation() -> Location {
        return (21.1458, 79.0882)
    }
}

let isPhone = UIDevice.current.userInterfaceIdiom == .phone

// MARK: Network Constants
enum NetworkConstants {
    case imageUrl(icon: String)
    case dataUrl(lac: Location)
    case searchLocation(query: String)

    private var urlScheme: String {
        return "https://"
    }

    private var subDomain: String {
        switch self {
        case .imageUrl:
            return "www."
        case .dataUrl, .searchLocation:
            return "api."
        }
    }

    private var baseUrl: String {
        return "openweathermap.org/"
    }

    private var endUrl: String {
        switch self {
        case .imageUrl(let icon):
            return "img/wn/\(icon)@4x.png"
        case .dataUrl(let location):
            return "data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(apiKey)&units=metric"
        case .searchLocation(let query):
            return "geo/1.0/direct?q=\(query)&limit=5&appid=\(apiKey)"
        }
    }

    private var apiKey: String {
        return "055dcfd56812dc37f9de94f643c2ff88"
    }

    func getUrl() -> String {
        return urlScheme + subDomain + baseUrl + endUrl
    }
}

enum AppStoryboard: String {

    case homeLanding = "HomeLanding"
    case searchPage = "SearchPage"
    case sheetPresenter = "SheetPresenter"

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}
