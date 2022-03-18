//
//  UIImageView+Extension.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 16/03/22.
//

import UIKit
import Kingfisher

// MARK: - Kingfisher
extension UIImageView {
    func setImage(with urlString: String, placeholder: UIImage? = nil, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        self.kf.setImage(with: URL(string: urlString), options: animated ? [.transition(.fade(0.5))] : []) { [weak self] result in
            switch result {
            case .success:
                completion?(true)
            case .failure:
                self?.image = placeholder
                completion?(false)
            }
        }
    }
}
