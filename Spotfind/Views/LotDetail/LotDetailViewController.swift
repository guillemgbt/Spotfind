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
    
    
    init(lotID: String) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        setParallaxHeader()
        setUI()
        
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
}


extension LotDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }
    
    
}
