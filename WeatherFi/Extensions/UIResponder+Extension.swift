//
//  UIResponder+Extension.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 19/03/22.
//

import UIKit

extension UIResponder {
    func getResponderOfType<T>(classType: T.Type) -> T? {
        guard let nextResponder = next else { return nil }
        if nextResponder.isKind(of: classType as! AnyClass) {
            return nextResponder as? T
        } else {
            return nextResponder.getResponderOfType(classType: classType)
        }
    }
}
