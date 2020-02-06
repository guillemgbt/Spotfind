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
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        updateLargeTitles()
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        updateLargeTitles()
        return vc
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let vc = super.popToRootViewController(animated: animated)
        updateLargeTitles()
        return vc
    }
    
    private func updateLargeTitles() {
        self.navigationBar.prefersLargeTitles = viewControllers.count < 2
    }


}
