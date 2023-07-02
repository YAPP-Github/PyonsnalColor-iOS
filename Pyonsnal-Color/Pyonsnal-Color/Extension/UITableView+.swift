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
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Unexpected identifier : \(T.identifier)")
        }
        return cell
    }
}

extension UITableViewCell: ItemIdentifier {}
