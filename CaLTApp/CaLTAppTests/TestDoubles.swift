//
//  TestDoubles.swift
//  CaLTAppTests
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/26.
//

import Foundation
@testable import CaLTApp

// MARK:- Test doubles

class PresenterSpy: CatListPresenterInterface {
   
    var presentCatsCalled = false
    var cats: [CatListModel.Response.Cat]?
    
    
    func displayCatList(axCatList: [CatListModel.Response.Cat]) {
        self.presentCatsCalled = true
        self.cats = axCatList
    }
    
    func showAlertError(errorHandler: ErrorHandler) {}
    func showLoading() {}
    func hideLoading() {}
}

class WorkerSpy: CatListWorkerInterface {
   
    var fetchCatsCalled = false
    var cats: [CatListModel.Response.Cat]?

    init(cats: [CatListModel.Response.Cat]?) {
        if cats != nil {
            self.cats = cats!
        }
    }
    
    func fetchCatList(request: CatListModel.Request, success: @escaping ([CatListModel.Response.Cat]?) -> (), fail: @escaping (ErrorHandler) -> ()) {
        self.fetchCatsCalled = true
        if cats != nil {
            success(cats!)
        }
    }
}

class ViewControllerSpy: CatListView {
  
    var displayFetchedCatsCalled = false
    var cats: [CatListViewModel] = []

    func displayCatList(axCatList: [CatListViewModel]) {
        self.displayFetchedCatsCalled = true
        self.cats = axCatList
    }
    
    func showLoading() {}
    func hideLoading() {}
    func showAlertError(errorHandler: ErrorHandler) {}
}

class InteractorSpy: CatListBusinessLogic {
   
    var fetchCatsCalled = false
    
    func fetchCatList(request: CatListModel.Request) {
        fetchCatsCalled = true
    }
    
    func showLoading() {}
}
