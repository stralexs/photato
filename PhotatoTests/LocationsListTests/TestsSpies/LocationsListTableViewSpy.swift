//
//  LocationsListTableViewSpy.swift
//  PhotatoTests
//
//  Created by Alexander Sivko on 7.08.23.
//

import UIKit
@testable import Photato

final class LocationsListTableViewSpy: UITableView {
    private(set) var isCalledReloadData = false
    
    override func reloadData() {
        super.reloadData()
        isCalledReloadData = true
    }
}
