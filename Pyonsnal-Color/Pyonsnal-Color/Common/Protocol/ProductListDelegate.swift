//
//  ProductListDelegate.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/09.
//

import Foundation

protocol ProductListDelegate: AnyObject {
    func didLoadPageList(store: ConvenienceStore)
    func refreshByPull()
    func didSelect(with product: ProductConvertable?)
    
    func updateFilterState(with filter: FilterItemEntity)
}
