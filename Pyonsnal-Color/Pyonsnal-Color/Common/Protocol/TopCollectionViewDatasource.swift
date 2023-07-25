//
//  TopCollectionViewDatasource.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/23.
//

import UIKit

class TopCollectionViewDatasource {
    enum SectionType: Hashable {
        case convenienceStore(store: [String])
        case filter
    }
    
    enum ItemType: Hashable {
        case convenienceStore(storeName: String)
        case filter(filterItem: FilterCellItem)
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
}
