//
//  AllExtensions.swift
//  Drawer Menu App
//
//  Created by MAC on 06/10/2023.
//

import UIKit

extension UITableView {
    func disableCellReuse() {
        for cellClass in [UITableViewCell.self] {
            let reuseIdentifier = NSStringFromClass(cellClass)
            if let nib = Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") {
                let nibCell = UINib(nibName: reuseIdentifier, bundle: nil)
                register(nibCell, forCellReuseIdentifier: reuseIdentifier)
            } else {
                register(cellClass, forCellReuseIdentifier: reuseIdentifier)
            }
        }
    }
}
