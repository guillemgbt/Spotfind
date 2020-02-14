//
//  FlightControl.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 24/04/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import SwiftyJSON
import RealmSwift

enum FlightState: String {
    case landed = "LANDED"
    case starting = "STARTING"
    case scanning = "SCANNING"
    case stopping = "STOPPING"
    case error = "ERROR"
    case initial = "INITIAL"
}

class FlightControl: GeneralObject {
    
    @objc dynamic var state: String = FlightState.initial.rawValue
    @objc dynamic var lot_id: Int = -1
    
    convenience init?(fromJSON json: JSON) {
        
        guard let id = json["id"].int,
                let state = FlightState(rawValue: json["state"].stringValue),
                let lotID = json["lot_id"].int else {
            return nil
        }
        
        self.init(id: "\(id)",
                  state: state.rawValue,
                  lotID: lotID,
                  created: json["created"].stringValue.toDate() ?? Date())
        
    }
    
    convenience init(id: String, state: String, lotID: Int, created: Date) {
        self.init(pk: id, created: created)
        self.state = state
        self.lot_id = lotID
    }
    
    func getState() -> FlightState {
        return FlightState(rawValue: state) ?? FlightState.error
    }
    
    func getLotID() -> Int {
        return lot_id
    }

}
