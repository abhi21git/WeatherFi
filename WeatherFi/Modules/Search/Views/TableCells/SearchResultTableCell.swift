//
//  SearchResultTableCell.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 19/03/22.
//

import UIKit

class SearchResultTableCell: UITableViewCell, ReusableView, NibLoadableView {

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!

    // MARK: - Properties
//    var location: Location = Constants.fallBackLocation()

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    // MARK: - Methods
    private func setupUI() {
        containerView.setCornerRadius(16)
    }

    func configureCell(with data: SearchResultDataModel) {
        nameLabel.text = data.name + ", " + data.state
        latitudeLabel.text = "Latitude: \(data.latitude)"
        longitudeLabel.text = "Longitude: \(data.longitude)"
//        location = (data.latitude, data.longitude)
    }

}
