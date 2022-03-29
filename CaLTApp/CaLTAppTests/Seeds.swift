//
//  Seeds.swift
//  CaLTAppTests
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/26.
//

import Foundation
@testable import CaLTApp

class Seeds {
    func loadCatListFromJson() -> [CatListModel.Response.Cat]? {
        
        if let path = Bundle.main.path(forResource: "CatJSONResponse", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                   let decoder = JSONDecoder()
                   let catArray = try decoder.decode([CatListModel.Response.Cat].self, from: data)
                   return catArray
            } catch _ {
                return nil
            }
        } else {
            return nil
        }
    }
}
