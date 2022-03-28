//
//  CatListPresenter.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import Foundation

protocol CatListPresenterInterface {
    func displayCatList(axCatList: [CatListModel.Response.Cat])
    func showLoading()
    func hideLoading()
    func showAlertError(errorHandler: ErrorHandler)
}

class CatListPresenter: CatListPresenterInterface {
    
    var catListView: CatListView!
    
    init(viewController: CatListView) {
        self.catListView = viewController
    }
    
    func displayCatList(axCatList: [CatListModel.Response.Cat]) {
        var displayedCats: [CatListViewModel] = []
        
        for cat in axCatList {
            let displayedCat = CatListViewModel(id: cat.id ?? "", name: cat.name ?? "", origin: cat.origin ?? "", image: cat.image?.url ?? "", temperament: cat.temperament ?? "", energyLevel: cat.energyLevel ?? 0)
            displayedCats.append(displayedCat)
        }
        self.catListView.displayCatList(axCatList: displayedCats)
    }
    
    func showLoading() {
        self.catListView.showLoading()
    }
    
    func hideLoading() {
        self.catListView.hideLoading()
    }
    
    func showAlertError(errorHandler: ErrorHandler) {
        self.catListView.showAlertError(errorHandler: errorHandler)
    }
}
