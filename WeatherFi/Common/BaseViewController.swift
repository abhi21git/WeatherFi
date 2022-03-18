//
//  BaseViewController.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 17/03/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add code here
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Add code here
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Add code here
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Add code here
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Add code here
    }
    
    //MARK: - Methods
    private func configureUI() {
        self.view.backgroundColor = UIColor.accentColor
    }
    
}

//MARK: - HomeLandingVC Extension
extension HomeLandingVC {
    
}
