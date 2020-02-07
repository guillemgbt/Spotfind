//
//  SpotRepo.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 29/01/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa
import SwiftyJSON


class SpotRepo: GeneralObjectRepo<Spot> {

    static let shared = SpotRepo()
    
    func getSpots(for area: Lot) -> Results<Spot> {
        return getSpots(for: area.getPK())
    }
    
    func getSpots(for lotID: String) -> Results<Spot> {
        let lotPredicate = NSPredicate(format: "lot_id == %@", lotID)
        return getObjectResults(filteredBy: lotPredicate)
    }
    
    func getSortdEvents(for lotID: String) -> Results<Spot> {
        let lotPredicate = NSPredicate(format: "lot_id == %@", lotID)
        return getSortedObjectResults(filteredBy: lotPredicate)
    }
    
    
    override func fetch(withKey key: String, toUpdate networkObject: BehaviorRelay<NetworkObject<Spot>?>) {
        
        networkObject.update(withNetworkStatus: .loading)
        
        api.get(requestPath: RequestPath(path: "spot/\(key)/"), onSuccess: { (json) in
            
            guard let spot = Spot(fromJSON: json) else {
                Utils.printDebug(sender: self, message: "Could not parse Lot from JSON")
                networkObject.update(withNetworkStatus: .error)
                return
            }
            
            self.updateStored(object: spot)
            
            networkObject.update(withNetworkStatus: .success,
                                 withObjectId: spot.getPK())
            
        }) { (description, _) in
            
            Utils.printDebug(sender: self, message: "error getting lot \(key): \(description)")
            networkObject.update(withNetworkStatus: .error)
            
        }
        
    }
    
    override func fetchList(withKey key: String, toUpdate networkState: BehaviorRelay<NetworkRequestState>) {
                
        networkState.accept(.loading)
        
        api.get(requestPath: RequestPath(path: "lot/\(key)/spots/"), onSuccess: { (json) in
            
            let spots = json.arrayValue.compactMap { Spot(fromJSON: $0) }
            self.replaceLotSpots(spots, lotID: key)
            
            networkState.accept(.success)

        }) { (description, _) in
            
            Utils.printDebug(sender: self, message: "error getting lots")
            networkState.accept(.error)
        }
        
    }
    
    private func replaceLotSpots(_ spots: [Spot], lotID: String) {
        let lotPredicate = NSPredicate(format: "lot_id == %@", lotID)
        replaceStored(objects: spots, categoryPredicate: lotPredicate)
    }
    
}
