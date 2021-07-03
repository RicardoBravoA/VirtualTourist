//
//  UIViewController+Extensions.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 3/07/21.
//

import UIKit

extension UIViewController {
    
    func showAlertController(message: String) {
        let alertController = UIAlertController(title: "Virtual Tourist", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func buttonEnabled(_ enabled: Bool, button: UIButton) {
        button.isEnabled = enabled
        button.alpha = enabled ? 1.0 : 0.5
    }
    
}
