//
//  SFNavigationViewController.swift
//  Spotfind
//
//  Created by Guillem Budia Tirado on 04/02/2020.
//  Copyright © 2020 uccs. All rights reserved.
//

import UIKit

class SFNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.prefersLargeTitles = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        updateLargeTitles(in: viewController)
    }
    
    
    private func updateLargeTitles(in vc: UIViewController?) {
        
        let mode = viewControllers.count < 2 ?
            UINavigationItem.LargeTitleDisplayMode.always :
            UINavigationItem.LargeTitleDisplayMode.never
        
        vc?.navigationItem.largeTitleDisplayMode = mode
        
    }


}
