//
//  CatListInteractor.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import Foundation

protocol CatListBusinessLogic {
    func fetchCatList(request: CatListModel.Request)
    func showLoading()
}

final class CatListInteractor: CatListBusinessLogic {
    
    var presenter: CatListPresenterInterface!
    var worker: CatListWorkerInterface!
    
    init(presenter: CatListPresenterInterface, worker:
        CatListWorkerInterface = CatListWorker(with: CatListService())) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchCatList(request: CatListModel.Request) {
        self.showLoading()
        worker.fetchCatList(request: request) { catList in
            if let catList = catList {
                self.presenter.displayCatList(axCatList: catList)
            }
            self.presenter.hideLoading()
        } fail: { errorHandler in
            self.presenter.hideLoading()
            self.presenter.showAlertError(errorHandler: errorHandler)
        }
    }
    
    func showLoading() {
        self.presenter.showLoading()
    }
}
