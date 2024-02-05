//
//  TabBarController.swift
//  Photato
//
//  Created by Alexander Sivko on 5.08.23.
//

import UIKit

final class TabBarController: UITabBarController {
    private let networkMonitor = NetworkConnectionMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarAppearance()
        tabBarSettings()
    }
    
    private func setTabBarAppearance() {
        tabBar.tintColor = .darkOliveGreen
        tabBar.unselectedItemTintColor = .tortilla
        tabBar.backgroundColor = .lightTortilla
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
    }
    
    private func tabBarSettings() {
        networkMonitor.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension TabBarController: NetworkConnectionStatusDelegate {}
