//
//  CatListRouter.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import Foundation
import UIKit
import SwiftUI

protocol CatListRouterInterface {
    func navigateToCatDetailView(catViewModel: CatListViewModel)
}


final class CatListRouter: CatListRouterInterface {
    
    weak var viewController: CatListViewController?
    
    func navigateToCatDetailView(catViewModel: CatListViewModel) {
        let detailVModel = CatDetailViewModel(id: catViewModel.id, name: catViewModel.name, origin: catViewModel.origin, image: catViewModel.image, temperament: catViewModel.temperament, energyLevel: catViewModel.energyLevel)
        let swiftUIDetailController = UIHostingController(rootView: CatDetailView().environmentObject(detailVModel))
        viewController?.navigationController?.pushViewController(swiftUIDetailController, animated: true)
    }
}
