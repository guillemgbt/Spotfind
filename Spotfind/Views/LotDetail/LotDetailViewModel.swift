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
    private let flightRepo: FlightControlRepo
    private let lotNetworkObject: BehaviorRelay<NetworkObject<Lot>?>
    private let bag = DisposeBag()
    
    private let name: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let occupancy: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let tendencyIcon: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    private let lotImageURL: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    
    private var spots: Results<Spot>
    private let spotsRequest: BehaviorRelay<NetworkRequestState> = BehaviorRelay(value: .initial)
    private let isFilteringSpots: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    private var timer: Timer?
    
    init(lotID: String,
         lotRepo: LotRepo = LotRepo.shared,
         spotRepo: SpotRepo = SpotRepo.shared,
         flightRepo: FlightControlRepo = FlightControlRepo.shared) {
        
        self.lotID = lotID
        self.lotRepo = lotRepo
        self.spotRepo = spotRepo
        self.flightRepo = flightRepo
        self.lotNetworkObject = BehaviorRelay(value: nil)
        self.spots = spotRepo.getFreeSpots(for: lotID)
        super.init()
        
        bindNetworkObject()
        setRequestTimer()
    }
    
    deinit {
        Utils.printDebug(sender: self, message: "deinit")
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
            
        }, onNetworkStatusUpdate: { [weak self] (networkStatus) in
            Utils.printDebug(sender: self, message: "lot request state: \(networkStatus)")
        }, withDisposeBag: bag)
                
    }
    
    private func setRequestTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { [weak self] _ in
            self?.fetchData()
        })
    }
    
    func fetchData() {
        
        lotRepo.fetchNetworkObject(withPK: lotID,
                                   withFetchingFrequency: .always,
                                   networkObjectObservable: lotNetworkObject)
        
        spotRepo.fetchList(withKey: lotID,
                           toUpdate: spotsRequest)
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
    
    func spotsObservable() -> Observable<Results<Spot>> {
        return Observable.collection(from: spots)
    }
    
    func isFilteringObservable() -> Observable<Bool> {
        return isFilteringSpots.asObservable()
    }
    
    func requestFlightStart() {
        flightRepo.requestStart(for: lotID)
    }
    
    func requestFlightStop() {
        flightRepo.requestStop(for: lotID)
    }
    
    func handleSwitch(active: Bool) {
        if active {
            spots = spotRepo.getFreeSpots(for: lotID)
        } else {
            spots = spotRepo.getSpots(for: lotID)
        }
        
        isFilteringSpots.accept(active)
    }

}
