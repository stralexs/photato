//
//  TabBarController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarAppearance()
    }
    
    func setTabBarAppearance() {
        tabBar.tintColor = .darkOliveGreen
        tabBar.unselectedItemTintColor = .tortilla
        tabBar.backgroundColor = .lightTortilla
    }
}
