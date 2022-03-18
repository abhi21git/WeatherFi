//
//  HomeLandingVC.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 15/03/22.
//

import UIKit

//MARK: - HomeLandingVC
class HomeLandingVC: BaseViewController {
    
    //MARK: - Properties
    var homeVM = HomeViewModel()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add code here
        setupUI()
        fetchData()
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
    
    //MARK: - Methods
    private func setupUI() {
        
    }

    private func fetchData() {
        let location = Location(2,2)
        homeVM.fetchWeather(for: location) { success in
            // Add code here
        }
    }
}

//MARK: - HomeLandingVC Extension
extension HomeLandingVC {
    
}
