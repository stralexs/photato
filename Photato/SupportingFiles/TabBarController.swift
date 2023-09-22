//
//  TabBarController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarAppearance()
        setNavigationBar()
    }
    
    private func setTabBarAppearance() {
        tabBar.tintColor = .darkOliveGreen
        tabBar.unselectedItemTintColor = .tortilla
        tabBar.backgroundColor = .lightTortilla
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage ()
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
