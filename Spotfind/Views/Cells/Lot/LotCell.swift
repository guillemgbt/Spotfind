//
//  LotCell.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 05/02/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import UIKit

class LotCell: UITableViewCell, NibLoadableView {

    
    @IBOutlet weak var lotImageView: UIImageView!
    @IBOutlet weak var lotNameLabel: UILabel!
    @IBOutlet weak var lotDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lotImageView.makeCircular()
    }
    
    func set(with lot: Lot) {
        self.lotImageView.loadImage(withURL: lot.getImageURL())
        self.lotNameLabel.text = lot.getName()
        
        let occStr = String(format: "%.0f", (lot.getRelativeOccupancy() ?? 0.0)*100)
        self.lotDetailLabel.text = occStr+"% at \(lot.lastUpdate().formatToHHdMMMYYYYSS())"
    }

}
