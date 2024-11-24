//
//  ViewController+Alerts.swift
//  CameraModule
//
//  Created by Kathryn Verkhogliad on 22.11.2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String = "", confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            confirmAction()
            
            alert?.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
