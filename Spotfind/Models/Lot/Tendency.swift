//
//  Tendency.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 06/02/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import Foundation
import UIKit

enum Tendency: String {
    case higher = "HIGHER"
    case high = "HIGH"
    case same = "SAME"
    case low = "LOW"
    case lower = "LOWER"
    
    var icon: UIImage? {
        get {
            switch self {
            case .higher:
                return #imageLiteral(resourceName: "higher")
            case .high:
                return #imageLiteral(resourceName: "high")
            case .same:
                return nil
            case .low:
                return #imageLiteral(resourceName: "low")
            case .lower:
                return #imageLiteral(resourceName: "lower")
            }
        }
    }
}
