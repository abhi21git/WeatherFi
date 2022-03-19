//
//  SearchPageVC.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 19/03/22.
//

import UIKit

//MARK: - Search Page VC
class SearchPageVC: BaseViewController {

    //MARK: - IBOutets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!

    //MARK: - Properties
    let searchVM = SearchViewModel()


    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTextField()
        setupTableView()
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
    @IBAction func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldTextDidChanged() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(fetchSearchResult(for:)), with: searchTextField.text, afterDelay: 1.0)
    }
    
    @IBAction func clearButtonAction() {
        searchTextField.text = ""
        searchVM.searchData.removeAll()
        resultTableView.reloadData()
    }

    //MARK: - Methods
    private func setupUI() {

    }

    private func setupTextField() {
        searchTextField.delegate = self
    }

    private func setupTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }

    @objc fileprivate func fetchSearchResult(for city: String) {
        guard city.count >= 3 else { return }
        activityIndicator.isHidden = false
        searchVM.fetchResults(for: city) { [weak self] success in
            self?.activityIndicator.isHidden = true
            if success {
                self?.resultTableView.reloadData()
            } else {

            }
        }
    }

    private func openDetailPage(for location: Location) {
        let detailVC = HomeLandingVC.instantiate(from: .homeLanding)
        detailVC.newLocation = location
        self.presentInBottomSheet(detailVC)
    }

}

//MARK: - SearchPageVC Extension
extension SearchPageVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        fetchSearchResult(for: textField.text ?? "")
        return true
    }
}

extension SearchPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchVM.searchData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell: SearchResultTableCell = tableView.dequeueReusableCell(for: indexPath)
        resultCell.configureCell(with: searchVM.searchData[indexPath.row])
        return resultCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location: Location = (searchVM.searchData[indexPath.row].latitude, searchVM.searchData[indexPath.row].longitude)
        openDetailPage(for: (location))
    }

}
