//
//  LotDetailViewController.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 05/02/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealm
import ParallaxHeader


class LotDetailViewController: UIViewController {

    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lotNameLabel: UILabel!
    @IBOutlet weak var lotImageView: UIImageView!
    @IBOutlet weak var occupancyLabel: UILabel!
    @IBOutlet weak var tendencyIconImage: UIImageView!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var minHeightView: UIView!
    @IBOutlet weak var spotSwitch: UISwitch!
    
    let viewModel: LotDetailViewModel
    let bag = DisposeBag()
    
    
    init(lotID: String) {
        self.viewModel = LotDetailViewModel(lotID: lotID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setParallaxHeader()
        setTableView()
        setUI()
        bindObservables()
        
        viewModel.fetchData()
    }
    
    private func bindObservables() {
        bindName()
        bindOccupancy()
        bindTendency()
        bindLotImage()
        bindIsFiltering()
        bindLots()
    }
    
    private func setTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.registerNib(SpotCell.self)
    }
    
    private func bindName() {
        viewModel.nameObservable().bindInUI { [weak self] name in
            self?.lotNameLabel.text = name
            self?.title = name
        }.disposed(by: bag)
    }
    
    private func bindOccupancy() {
        viewModel.occupancyObservable().bindInUI { [weak self] occupancy in
            self?.occupancyLabel.text = occupancy
        }.disposed(by: bag)
    }
    
    private func bindTendency() {
        viewModel.tendencyIconObservable().bindInUI { [weak self] icon in
            self?.tendencyIconImage.loadImage(withImage: icon)
        }.disposed(by: bag)
    }
    
    private func bindLotImage() {
        viewModel.lotImageURLObservable().bindInUI { [weak self] imageURL in
            self?.lotImageView.loadImage(withURL: imageURL)
        }.disposed(by: bag)
    }
    
    private func bindIsFiltering() {
        viewModel.isFilteringObservable().skip(1).bindInUI { [weak self] _ in
            self?.tableView.dataSource = nil
            self?.bindLots()
        }.disposed(by: bag)
    }
    
    private func bindLots() {
        
        viewModel.spotsObservable()
            .bind(to: tableView.rx.items) {tableView, row, spot in
            
                let cell: SpotCell = tableView.dequeueReusableCell(for: IndexPath(row: row,
                                                                                 section: 0))
                cell.set(with: spot)
                return cell
            }
            .disposed(by: bag)
    }
    
    private func setUI() {
        panelView.makeRound(radiusPoints: 8)
        panelView.setSuperPosedShadow()
    }
    
    private func setParallaxHeader() {
        self.headerView.removeFromSuperview()
        tableView.parallaxHeader.view = headerView
        tableView.parallaxHeader.height = 400
        tableView.parallaxHeader.minimumHeight = minHeightView.bounds.height
        tableView.parallaxHeader.mode = .fill
    }
    
    @IBAction func onSwitchChanged(_ sender: Any) {
        Utils.printDebug(sender: self, message: "switch changed")
        viewModel.handleSwitch(active: spotSwitch.isOn)
    }
}
