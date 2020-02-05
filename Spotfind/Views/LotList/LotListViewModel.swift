//
//  LotListViewModel.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 04/02/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRealm
import RealmSwift


class LotListViewModel: NSObject {
    
    private let lotRepo: LotRepo
    
    private let title: BehaviorRelay<String> = BehaviorRelay(value: "Spotfind")
    private let requestState: BehaviorRelay<NetworkRequestState> = BehaviorRelay(value: .initial)
    private let vcToPresent: BehaviorRelay<UIViewController?> = BehaviorRelay(value: nil)
    private let vcToPush: BehaviorRelay<UIViewController?> = BehaviorRelay(value: nil)
    private let lots: Results<Lot>

    
    init(lotRepo: LotRepo = LotRepo.shared) {
        self.lotRepo = lotRepo
        self.lots = lotRepo.getSortedObjectResults()
        super.init()
    }
    
    func titleObservable() -> Observable<String> {
        return title.asObservable()
    }
    
    func isLoadingObservable() -> Observable<Bool> {
        return requestState.map { $0 == .loading }
    }
    
    func errorOccurred() -> Observable<Bool> {
        return requestState.map { $0 == .error }
    }
    
    func lotsObservable() -> Observable<Results<Lot>> {
        return Observable.collection(from: lots)
    }
    
    func requestLots() {
        lotRepo.fetchList(networkState: requestState)
    }
    
    func handleLotSelection(at indexPath: IndexPath) {
        Utils.printDebug(sender: self, message: "Selected \(indexPath.row)")
    }

}
