//
//  NavControl.swift
//  CleanSwiftByReni
//
//  Created by Bootcamp on 16/05/19.
//  Copyright © 2019 Bootcamp. All rights reserved.
//

import UIKit

class InteractivePopNavigationController: UINavigationController {
    var isPushingViewController = false
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isPushingViewController = true
        super.pushViewController(viewController, animated: animated)
    }
}

// 6
extension InteractivePopNavigationController: UIGestureRecognizerDelegate {
    private func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) &gt; Bool {
    guard gestureRecognizer is UIScreenEdgePanGestureRecognizer else { return true }
    return viewControllers.count &gt; 1 &amp;&amp; !isPushingViewController
    }
}

// 4
extension InteractivePopNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isPushingViewController = false
    }
}
