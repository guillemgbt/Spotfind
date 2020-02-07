//
//  LotListViewController.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 04/02/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealm

class LotListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = LotListViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setNavigationBarItems()
        bindObservables()
        viewModel.requestLots()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        deselectRowsIfNeeded()
    }
    
    private func deselectRowsIfNeeded() {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func setTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.registerNib(LotCell.self)
        setPullToRefresh()
    }
    
    private func setPullToRefresh() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(onPullToRefresh(_:)),
                          for: .valueChanged)
        tableView.refreshControl = control
    }
    
    private func setNavigationBarItems() {
        setRightNavigationItem(view: activityIndicator)
    }
    
    private func bindObservables() {
        bindTitle()
        bindLots()
        bindLoading()
        bindError()
        bindVCtoPush()
    }
    
    private func bindTitle() {
        viewModel.titleObservable().bindInUI { [weak self] title in
            self?.title = title
        }.disposed(by: bag)
    }
    
    private func bindLots() {
        
        viewModel.lotsObservable()
            .bind(to: tableView.rx.items) {tableView, row, lot in
            
                let cell: LotCell = tableView.dequeueReusableCell(for: IndexPath(row: row,
                                                                                 section: 0))
                cell.set(with: lot)
                return cell
            }
            .disposed(by: bag)
        
        tableView.rx.itemSelected.asObservable()
            .bind { [weak self] (indexPath) in
                self?.viewModel.handleLotSelection(at: indexPath)
            }
            .disposed(by: bag)
    }
    
    private func bindLoading() {
        viewModel.isLoadingObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel.isLoadingObservable().bindInUI { [weak self] (isLoading) in
            if isLoading && self?.tableView.refreshControl?.isRefreshing ?? false {
                self?.tableView.refreshControl?.endRefreshing()
            }
        }.disposed(by: bag)
        
    }
    
    private func bindError() {
        viewModel.errorOccurred().bindInUI { [weak self] (errorOccurred) in
            if errorOccurred {
                self?.showMessage(title: "Could not fetch lots!",
                                  message: "Please, pull to refresh data.")
            }
        }.disposed(by: bag)
    }
    
    private func bindVCtoPush() {
        observeForNavigation(to: viewModel.vcToPush).disposed(by: bag)
    }
    
    @objc private func onPullToRefresh(_ sender: Any) {
        viewModel.requestLots()
    }
    

}
