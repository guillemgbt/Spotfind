//
//  Lot.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 28/01/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


class Lot: GeneralObject {
        
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    let occupancy = RealmOptional<Float>()
    @objc dynamic var tendency: String = ""
    
    convenience init?(fromJSON json: JSON) {
        
        guard let id = json["id"].int else {
            return nil
        }
        
        self.init(id: "\(id)",
                name: json["name"].stringValue.html2String,
                image: json["image"].stringValue,
                occupancy: json["occupancy"].float,
                tendency: json["tendency"].stringValue,
                created: json["created"].stringValue.toDate() ?? Date(),
                updated: json["updated"].stringValue.toDate() ?? Date())

        
    }
    
    convenience init(id: String, name: String, image: String, occupancy: Float?, tendency: String, created: Date, updated: Date) {
                
        self.init(pk: id, created: created)
        self.name = name
        self.image = image
        self.occupancy.value = occupancy
        self.tendency = tendency
        self.updatedAt = updated
    }
    
    @objc func getName() -> String {
        return self.name
    }
    
    func getImageURL(api: API = API.shared) -> URL? {
        return URL(string: api.completeImageURL(image))
    }
    
    func getRelativeOccupancy() -> Float? {
        return self.occupancy.value
    }
    
    @objc func getTendency() -> String {
        return self.tendency
    }
    
}
