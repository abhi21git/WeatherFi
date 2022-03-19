//
//  BaseViewController.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 17/03/22.
//

import UIKit

//MARK: - Base View Controller
class BaseViewController: UIViewController {


    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
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
