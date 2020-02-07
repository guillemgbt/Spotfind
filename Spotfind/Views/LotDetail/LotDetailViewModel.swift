//
//  LotDetailViewModel.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 05/02/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRealm
import RealmSwift

class LotDetailViewModel: NSObject {
    
    private let lotID: String
    private let lotRepo: LotRepo
    private let spotRepo: SpotRepo
    private let lotNetworkObject: BehaviorRelay<NetworkObject<Lot>?>
    private let bag = DisposeBag()
    
    private let name: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let occupancy: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let tendencyIcon: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    private let lotImageURL: BehaviorRelay<URL?> = BehaviorRelay(value: nil)

    
    init(lotID: String,
         lotRepo: LotRepo = LotRepo.shared,
         spotRepo: SpotRepo = SpotRepo.shared) {
        
        self.lotID = lotID
        self.lotRepo = lotRepo
        self.spotRepo = spotRepo
        self.lotNetworkObject = BehaviorRelay(value: nil)
        super.init()
        
        bindNetworkObject()
        
    }
    
    private func bindNetworkObject() {
        
        lotNetworkObject.observe(onObjectUpdate: { [weak self] (lot) in
            Utils.printDebug(sender: self, message: "lot reveiced: \(lot.getName())")
            
            self?.name.accept(lot.getName())
            self?.lotImageURL.accept(lot.getImageURL())
            if let occ = lot.getRelativeOccupancy() {
                let occStr = String(format: "%.0f", occ*100)
                self?.occupancy.accept(occStr+"% of occupancy")
            }
            if let tendency = Tendency(rawValue: lot.getTendency()) {
                self?.tendencyIcon.accept(tendency.icon)
            }
            
        }, onNetworkStatusUpdate: { (networkStatus) in
            Utils.printDebug(sender: self, message: "lot request state: \(networkStatus)")
        }, withDisposeBag: bag)
                
    }
    
    func fetchLot() {
        
        lotRepo.fetchNetworkObject(withPK: lotID,
                                   withFetchingFrequency: .always,
                                   networkObjectObservable: lotNetworkObject)
    }
    
    func nameObservable() -> Observable<String> {
        return name.asObservable()
    }
    
    func occupancyObservable() -> Observable<String> {
        return occupancy.asObservable()
    }
    
    func tendencyIconObservable() -> Observable<UIImage?> {
        return tendencyIcon.asObservable()
    }
    
    func lotImageURLObservable() -> Observable<URL?> {
        return lotImageURL.asObservable()
    }

}
