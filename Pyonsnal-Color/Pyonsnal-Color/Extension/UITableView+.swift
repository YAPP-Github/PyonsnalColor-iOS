//
//  UITableView+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/27.
//

import UIKit

extension UITableView {
    func register(_ cellClass: AnyClass) {
        register(cellClass.self, forCellReuseIdentifier: String(describing: cellClass.self))
    }
}
