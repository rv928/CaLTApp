//
//  UIViewController+ProgressHUD.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/26.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    
    func showProgressHUD() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.show()
    }
    
    func hideProgressHUD() {
        SVProgressHUD.dismiss()
    }
}
