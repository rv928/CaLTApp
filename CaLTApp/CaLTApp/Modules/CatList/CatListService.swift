//
//  CatListService.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import Foundation

final class CatListService {
 
    func fetchCatlist(request: CatListModel.Request,
                      success: @escaping (_ data: Data?) -> (),
                      fail: @escaping (_ errorHandler: ErrorHandler) -> ()) {
        let api = APIManager.init(endpoint: .fetchCatList)
        var dict: [String:Any] = [String:Any]()
        dict["limit"] = request.limit
        dict["page"] = request.page
        api.call(parameters: dict, headersAdditional: nil, encoding: nil, fail: { (dataResponse) in
            fail(ErrorHandler(response: dataResponse!))
        }) { (jsonData) in
            guard let jsonData = jsonData else { return }
            success(jsonData)
        }
    }
}
