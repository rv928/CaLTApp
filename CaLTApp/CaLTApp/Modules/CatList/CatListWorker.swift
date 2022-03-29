//
//  CatListWorker.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import Foundation

protocol CatListWorkerInterface {
    func fetchCatList(request: CatListModel.Request,
                      success: @escaping ([CatListModel.Response.Cat]?) -> (),
                      fail: @escaping (_ errorHandler: ErrorHandler) -> ())
}

final class CatListWorker: CatListWorkerInterface {
    
    var service: CatListService?
    
    init(with aService: CatListService) {
        service = aService
    }
    
    func fetchCatList(request: CatListModel.Request,
                      success: @escaping ([CatListModel.Response.Cat]?) -> (),
                      fail: @escaping (_ errorHandler: ErrorHandler) -> ()) {
        
        service?.fetchCatlist(request: request) { jsonData in
            if let jsonData = jsonData {
                do {
                    let decoder = JSONDecoder()
                    let couponsObject = try decoder.decode([CatListModel.Response.Cat].self, from: jsonData)
                    success(couponsObject)
                } catch {
                    print(error)
                    success(nil)
                }
            } else {
                fail(ErrorHandler(message: "No data"))
            }
            
        } fail: { errorHandler in
            fail(errorHandler)
        }
    }
}
