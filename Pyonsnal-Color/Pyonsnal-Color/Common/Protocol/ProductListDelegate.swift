//
//  ProductListDelegate.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/09.
//

import Foundation

protocol ProductListDelegate: AnyObject {
    func didLoadPageList(store: ConvenienceStore)
    func refreshByPull(with filterList: [String])
    func didSelect(with product: ProductConvertable?)
    
    func updateFilterState(with filter: FilterItemEntity, isSelected: Bool)
    func refreshFilterButton()
    func didAppearProductList()
    func didFinishUpdateSnapshot()
}
