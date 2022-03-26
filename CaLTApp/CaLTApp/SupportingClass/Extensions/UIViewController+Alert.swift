//
//  UIViewController+Alert.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/26.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(errorHandler: ErrorHandler) {
        if let message = errorHandler.message {
            var message: String = message
            if errorHandler.parsableErrorCode!.count > 0 {
                message = message + "(" + "\(String(describing: errorHandler.parsableErrorCode!))" + ")"
            }
            let alertController = UIAlertController(title: errorHandler.title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
