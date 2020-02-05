//
//  UIViewController+Extensions.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 24/10/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    func getTopScreenPading() -> CGFloat? {
        
        if #available(iOS 11.0, *) {
            if let tp = UIApplication.shared.keyWindow?.safeAreaInsets.top, !tp.isZero {
                return tp
            }
        }
        return nil
    }
    
    func mapParallaxToFadingNavigationBarProgress(_ progress: CGFloat) -> CGFloat {
        
        var progressMapped = progress*2 - 0.5 //Mapping progress to [0, 2]
        
        if progressMapped.isNaN { progressMapped = 2 }
        
        if progressMapped > 1 { progressMapped = 1 } // Capping progress to [0, 1], half of the header compression
        
        return 1-progressMapped
    }
    
    /// Styles the navBar with a custom large title style
    /// It is recommended to be called in "onViewWillAppear"
    func setLargeTitleNavBar() {
        if #available(iOS 11.0, *) {
            if let navController = self.navigationController  {
                navController.view.backgroundColor = UIColor.white
                navController.navigationBar.prefersLargeTitles = true
                navController.navigationBar.isTranslucent = false //Sets background to be white
                navController.navigationBar.shadowImage = UIImage() //Removes bottom line
                
                //Updates title margins to be 24 for each side
                navController.navigationBar.layoutMargins.left = 24
                navController.navigationBar.layoutMargins.right = 24
                
            }
        }
    }
    
    func resetDefaultNavBar() {
        if #available(iOS 11.0, *) {
            if let navBar = self.navigationController?.navigationBar {
                navBar.prefersLargeTitles = false
                navBar.isTranslucent = true
                navBar.shadowImage = nil
            }
        }
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true, in navigationController: UINavigationController? = nil) {
        
        (navigationController ?? self.navigationController)?.pushViewController(viewController, animated: animated)
    }
    
    func observeForNavigation(to vcToPush: BehaviorRelay<UIViewController?>) -> Disposable {
        return vcToPush.asObservable().observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self, weak vcToPush] vc in
            guard let viewController = vc else { return }
            self?.push(viewController)
            vcToPush?.accept(nil)
        })
    }
    
    func observeForPresentation(to vcToPresent: BehaviorRelay<UIViewController?>,
                                animated: Bool = true,
                                completion: (() -> Void)? = nil) -> Disposable {
        return vcToPresent.asObservable().bindInUI { [weak self, weak vcToPresent] vc in
            guard let viewController = vc else { return }
            self?.present(viewController, animated: animated, completion: completion)
            vcToPresent?.accept(nil)
        }
    }
    
    func setRightNavigationItem(view: UIView) {
        let item = UIBarButtonItem(customView: view)
        self.navigationItem.setRightBarButton(item, animated: false)
    }
    
    func setLeftNavigationItem(view: UIView) {
        let item = UIBarButtonItem(customView: view)
        self.navigationItem.setLeftBarButton(item, animated: false)
    }
    
}

