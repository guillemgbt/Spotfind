//
//  LotRepo.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 29/01/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import RxSwift
import RxCocoa


class LotRepo: GeneralObjectRepo<Lot> {
    
    static let shared = LotRepo()
    
    override func fetch(withKey key: String, toUpdate networkObject: BehaviorRelay<NetworkObject<Lot>?>) {
        
        networkObject.update(withNetworkStatus: .loading)
        
        api.get(requestPath: RequestPath(path: "lot/\(key)/"), onSuccess: { (json) in
            
            guard let lot = Lot(fromJSON: json) else {
                Utils.printDebug(sender: self, message: "Could not parse Lot from JSON")
                networkObject.update(withNetworkStatus: .error)
                return
            }
            
            self.updateStored(object: lot)
            
            networkObject.update(withNetworkStatus: .success,
                                 withObjectId: lot.getPK())
            
        }) { (description, _) in
            
            Utils.printDebug(sender: self, message: "error getting lot \(key): \(description)")
            networkObject.update(withNetworkStatus: .error)
            
        }
        
    }
    
    func fetchList(networkState: BehaviorRelay<NetworkRequestState>) {
        
        networkState.accept(.loading)
        
        api.get(requestPath: RequestPath(path: "lots/"), onSuccess: { (json) in
            
            let lots = json.arrayValue.compactMap { Lot(fromJSON: $0) }
            self.replaceStored(objects: lots)
            
            networkState.accept(.success)

        }) { (description, _) in
            
            Utils.printDebug(sender: self, message: "error getting lots")
            networkState.accept(.error)
        }
        
    }
    
    
}
