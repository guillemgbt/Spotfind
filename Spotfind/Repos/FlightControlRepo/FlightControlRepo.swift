//
//  FlightControlRepo.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 24/04/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import RealmSwift
import RxSwift
import RxCocoa

class FlightControlRepo: GeneralObjectRepo<FlightControl> {
    
    static let shared: FlightControlRepo = FlightControlRepo()
    
    
    
    func fetch(networkState: BehaviorRelay<NetworkRequestState>? = nil) {
        
        networkState?.accept(.loading)

        api.get(requestPath: RequestPath(path: "flight/"), onSuccess: { (json) in
                        
            guard let control = FlightControl(fromJSON: json) else {
                Utils.printDebug(sender: self, message: "Could not parse Lot from JSON")
                networkState?.accept(.error)
                return
            }
            
            self.updateStored(object: control)
            
            networkState?.accept(.success)

            Utils.printDebug(sender: self, message: "Fetch success")
            
        }) { (description, dict) in
            
            networkState?.accept(.error)

            Utils.printError(sender: self, message: "Could not fetch: \(description)")
            
        }
        
    }
    
    func requestStart(for lotID: String, networkState: BehaviorRelay<NetworkRequestState>? = nil) {
        
        networkState?.accept(.loading)
        
        api.get(requestPath: RequestPath(path: "flight/lot/\(lotID)/start/"), onSuccess: { (json) in
            
            guard let control = FlightControl(fromJSON: json) else {
                Utils.printDebug(sender: self, message: "Could not parse Lot from JSON")
                networkState?.accept(.error)
                return
            }
            
            self.updateStored(object: control)
            
            
            networkState?.accept(.success)
            
            Utils.printDebug(sender: self, message: "Start success")
            
        }) { (description, dict) in
            
            networkState?.accept(.error)
            
            Utils.printError(sender: self, message: "Start error: \(description)")
            
        }
        
    }
    
    func requestStop(for lotID: String, networkState: BehaviorRelay<NetworkRequestState>? = nil) {
        
        networkState?.accept(.loading)
        
        api.get(requestPath: RequestPath(path: "flight/lot/\(lotID)/stop/"), onSuccess: { (json) in
            
            guard let control = FlightControl(fromJSON: json) else {
                Utils.printDebug(sender: self, message: "Could not parse Lot from JSON")
                networkState?.accept(.error)
                return
            }
            
            self.updateStored(object: control)
            
            networkState?.accept(.success)
            Utils.printDebug(sender: self, message: "Stop success")
            
        }) { (description, dict) in
            
            networkState?.accept(.error)
            
            Utils.printError(sender: self, message: "Stop error: \(description)")
            
        }
    }
    
    
    


}
