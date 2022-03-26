//
//  CatListRouter.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import Foundation

protocol CatListRouterInterface {}


final class CatListRouter: CatListRouterInterface {
    weak var viewController: CatListViewController!
}
