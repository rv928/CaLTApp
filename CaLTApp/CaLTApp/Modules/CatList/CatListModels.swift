//
//  CatListModels.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import Foundation

struct CatListModel {
    
    struct Request {
        let limit: Int?
        let page: Int?
    }
    struct Response {
        
        struct Cat: Codable {
            let id: String?
            let name: String?
            let origin: String?
            let image: Image?
            let temperament: String?
            let energyLevel: Int?
            
            enum CodingKeys: String, CodingKey {
                case id = "id"
                case name = "name"
                case origin = "origin"
                case image = "image"
                case temperament = "temperament"
                case energyLevel = "energyLevel"
            }
            
            init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decodeIfPresent(String.self, forKey: .id)
                name = try values.decodeIfPresent(String.self, forKey: .name)
                origin = try values.decodeIfPresent(String.self, forKey: .origin)
                image = try values.decodeIfPresent(Image.self, forKey: .image)
                temperament = try values.decodeIfPresent(String.self, forKey: .temperament)
                energyLevel = try values.decodeIfPresent(Int.self, forKey: .energyLevel)
            }
        }
        
        // MARK: - Image
        struct Image: Codable {
            let id: String?
            let width, height: Int?
            let url: String?
        }
    }
}

// Data struct sent to ViewController
class CatListViewModel {
    var id: String = ""
    var name: String = ""
    var origin: String = ""
    var image: String = ""
    var temperament: String = ""
    var energyLevel: Int?
    
    init(id: String, name: String, origin: String ,image: String, temperament: String, energyLevel: Int?) {
        self.id = id
        self.name = name
        self.origin = origin
        self.image = image
        self.temperament = temperament
        self.energyLevel = energyLevel
    }
}
