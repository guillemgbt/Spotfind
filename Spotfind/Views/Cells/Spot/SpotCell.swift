//
//  SpotCell.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 07/02/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import UIKit

class SpotCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var spotImageView: UIImageView!
    @IBOutlet weak var spotDescriptionLabel: UILabel!
    @IBOutlet weak var spotAuxLabel: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.spotImageView.makeCircular()
    }

    func set(with spot: Spot) {
        self.spotImageView.loadImage(withURL: spot.getImageURL())
        self.spotDescriptionLabel.text = spot.getDescription()
        self.spotAuxLabel.text = "Found at "+spot.getDetectionDate().formatToHHdMMMYYYYSS()
    }
    
}
