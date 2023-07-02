//
//  UICollectionView+.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/23.
//

import UIKit

extension UICollectionView {
    func register(_ viewClass: AnyClass) {
        register(viewClass, forCellWithReuseIdentifier: String(describing: viewClass.self))
    }
    
    func registerHeaderView(_ viewClass: AnyClass) {
        register(
            viewClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: viewClass.self)
        )
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Unexpected identifier : \(T.identifier)")
        }
        return cell
    }
}

extension UICollectionViewCell: ItemIdentifier {}
