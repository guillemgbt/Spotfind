//
//  Spot.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 28/01/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


class Spot: GeneralObject {
    
    @objc dynamic var image: String = ""
    @objc dynamic var is_free: Bool = false
    @objc dynamic var lot_id: String = ""
    
    convenience init?(fromJSON json: JSON) {
        
        guard let id = json["id"].int else {
            return nil
        }
        
        self.init(id: "\(id)",
                  image: json["title"].stringValue.html2String,
                  is_free: json["is_free"].boolValue,
                  lot_id: json["lot_id"].stringValue,
                  created: json["created"].stringValue.toDate() ?? Date())
        
        
    }
    
    convenience init(id: String, image: String, is_free: Bool, lot_id: String, created: Date) {
        
        self.init(pk: id, created: created)
        self.image = image
        self.is_free = is_free
        self.lot_id = lot_id
    }
    
    override static func indexedProperties() -> [String] {
        return ["pk", "is_free", "lot_id"]
    }

}
