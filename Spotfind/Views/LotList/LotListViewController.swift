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

        bindObservables()
        viewModel.requestLots()
    }
    
    private func setTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    private func setNavigationBarItems() {
        setRightNavigationItem(view: activityIndicator)
    }
    
    private func bindObservables() {
        bindTitle()
        bindLots()
        bindLoading()
        bindError()
    }
    
    private func bindTitle() {
        viewModel.titleObservable().bindInUI { [weak self] title in
            self?.title = title
        }.disposed(by: bag)
    }
    
    private func bindLots() {
        
        viewModel.lotsObservable()
            .bind(to: tableView.rx.items) {tableView, row, lot in
            
                let cell = UITableViewCell()
                cell.textLabel?.text = lot.getName()
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
    }
    
    private func bindError() {
        viewModel.errorOccurred().bindInUI { [weak self] (errorOccurred) in
            if errorOccurred {
                self?.showMessage(title: "Could not fetch lots!",
                                  message: "Please, pull to refresh data.")
            }
        }.disposed(by: bag)
    }
    

}
