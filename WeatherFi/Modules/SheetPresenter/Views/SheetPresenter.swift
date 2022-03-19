//
//  SheetPresenter.swift
//  WeatherFi
//
//  Created by Abhishek Maurya on 19/03/22.
//

import UIKit

class PresenterViewController: UIViewController {

    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var tapGestureView: UIView!
    @IBOutlet weak var baseViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var baseViewWidthConstraint: NSLayoutConstraint!

    private var tapGesture: UITapGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer?

    private var childController: UIViewController!

    var heightPercent: CGFloat = 0.80
    var controllerHeight: CGFloat = CGFloat() {
        willSet {
            if newValue == .zero || newValue > (self.view.frame.height * heightPercent) {
                baseViewHeightConstraint.constant = self.view.frame.height * heightPercent
            } else {
                baseViewHeightConstraint.constant = newValue
            }
            UIView.animate(withDuration: 0.3) {
                self.tapGestureView.layoutIfNeeded()
            }
        }
    }
    var controllerWidth: CGFloat = CGFloat() {
        willSet {
            if isPhone {
                baseViewWidthConstraint.constant = UIScreen.main.bounds.width
            } else if newValue == .zero {
                baseViewWidthConstraint.constant = 540.0
            } else {
                baseViewWidthConstraint.constant = newValue
            }
            UIView.animate(withDuration: 0.3) {
                self.tapGestureView.layoutIfNeeded()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        performAnimation(isOpeningAnimation: false, duration: 0.0, nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        addGesture()
        addChildController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performAnimation(isOpeningAnimation: true)
    }

    private func configureUI() {
        if isPhone {
            baseView.layer.cornerRadius = 15.0
            baseView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            handleView.setCornerRadius(3)
        } else {
            baseView.setCornerRadius(16)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func performAnimation(isOpeningAnimation: Bool, duration: TimeInterval = 0.3, _ completion: (() -> Void)? = nil) {
        if isOpeningAnimation {
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
                self.baseView.transform = .identity
                self.handleView.transform = .identity
                self.baseView.alpha = 1
                self.tapGestureView.viewWithTag(234)?.alpha = 0.95
                self.tapGestureView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            }) { _ in
                completion?()
            }
        } else {
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
                var tranformation: CGAffineTransform = isPhone ? CGAffineTransform(translationX: 0.0, y: UIScreen.main.bounds.height) : CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.baseView.transform = tranformation
                tranformation = tranformation.scaledBy(x: 0.001, y: 1.0)
                self.handleView.transform = tranformation
                self.baseView.alpha = isPhone ? 1.0 : 0.0
                self.tapGestureView.viewWithTag(234)?.alpha = 0
                self.tapGestureView.backgroundColor = UIColor.black.withAlphaComponent(0)
            }) { _ in
                completion?()
            }
        }
    }

    private func addChildController() {
        addChild(childController)
        childController.view.frame = baseView.bounds
        baseView.addSubview(childController.view)
        childController.didMove(toParent: self)
    }

    private func addGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController(touch:)))
        tapGesture?.delegate = self
        if let tapGestureRecogniser = tapGesture {
            tapGestureView.addGestureRecognizer(tapGestureRecogniser)
        }

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        panGesture?.delegate = self
        if let panGestureRecogniser = panGesture, isPhone {
            baseView.addGestureRecognizer(panGestureRecogniser)
        }
    }

    fileprivate static func initialize(with child: UIViewController) -> UIViewController {
        let presenter = PresenterViewController.instantiate(from: .sheetPresenter)
        let navController = UINavigationController.init(rootViewController: presenter)

        presenter.childController = child
        navController.modalPresentationStyle = .overFullScreen

        return navController
    }

    fileprivate func dismissSheet(completion: (() -> Void)? = nil) {
        performAnimation(isOpeningAnimation: false) {
            self.dismiss(animated: false, completion: completion)
        }
    }
}



extension PresenterViewController: UIGestureRecognizerDelegate {

    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == tapGesture && touch.view == tapGestureView {
            return true
        } else if gestureRecognizer == panGesture {
            return true
        }
        return false
    }

    @objc private func dismissController(touch: UITapGestureRecognizer) {
        dismissSheet()
    }

    @objc private func draggedView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)

        switch sender.state {
        case .ended:

            self.performAnimation(isOpeningAnimation: translation.y <= 150) {
                if translation.y > 150.0 {
                    self.dismiss(animated: false)
                }
            }

        case .changed:
            if translation.y > 0 {
                let normalisedTranslation = 1 - (translation.y / self.view.frame.height)
                var tranformation: CGAffineTransform = CGAffineTransform(translationX: 0.0, y: translation.y)
                baseView.alpha = 1
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.baseView.transform = tranformation
                    tranformation = tranformation.scaledBy(x: normalisedTranslation, y: 1.0)
                    self?.handleView.transform = tranformation
                    self?.tapGestureView.backgroundColor = UIColor.black.withAlphaComponent(normalisedTranslation / 2)
                }
            }

        default:
            break
        }

    }
}

extension UIViewController {
    var BottomSheet: PresenterViewController? {
        return self.getResponderOfType(classType: PresenterViewController.self)
    }

    func presentInBottomSheet(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        let sheetpresenter = PresenterViewController.initialize(with: viewController)
        self.present(sheetpresenter, animated: false, completion: completion)
    }

    func dismissBottomSheet(completion: (() -> Void)? = nil) {
        BottomSheet?.dismissSheet(completion: completion)
    }
}
