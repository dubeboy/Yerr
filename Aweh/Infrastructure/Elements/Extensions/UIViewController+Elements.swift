//
//  UIViewController+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/08.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol Storyborded {
    static func instantiate() -> Self
}

//MARK: View Controller initialization
extension Storyborded where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: String(describing: Self.self), bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
        return viewController
    }
}

extension UIViewController: Storyborded {
    func pushViewController<T: UIViewController>(_ fromNib: T) {
        let viewController = T.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: TOASTS
extension UIViewController {
    // TODO: - should be bale to show image animation
    func presentToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    func presentAlert(message: String, cancel: () -> Void, ok: () -> Void) {
        
    }
}

// MARK: Keyboard Events
extension UIViewController {
    func listenToEvent(
        name: NSNotification.Name,
        selector: Selector
    ) {
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: name,
            object: nil
        )
    }
    
    func removeSelfFromNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Keyboard
    func keyboardFrame(from notification: NSNotification) -> CGRect? {
        guard let userInfo = notification.userInfo else { return nil }
    
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue else { return nil }
    
        return keyboardSize.cgRectValue
    }
    
    // This value is import on ipads probaly add a check for ipads
    var spookyKeyboardHeightConstant: CGFloat {
        // TODO: 20 for iPad and 50 for tablet
        50
    }

}

// MARK: View Controller addition
// TODO: mention source!!!
extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

// MARK navigation item additions

extension UIViewController {
    func addCloseButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissViewController))
    }
    
    @objc private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
