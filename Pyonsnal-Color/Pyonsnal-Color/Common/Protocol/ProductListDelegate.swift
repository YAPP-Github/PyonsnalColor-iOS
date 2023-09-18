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
    func didSelect(with product: (any ProductConvertable)?)
    
    func deleteKeywordFilter(_ filter: FilterItemEntity)
    func refreshFilterButton()
    func didAppearProductList()
    func didFinishUpdateSnapshot()
}
