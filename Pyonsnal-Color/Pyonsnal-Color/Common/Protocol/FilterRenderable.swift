//
//  FilterRenderable.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/08/26.
//

import Foundation

protocol FilterRenderable {
    var filterStateManager: FilterStateManager? { get set }
    var filterDataEntity: FilterDataEntity? { get }
    var selectedFilterCodeList: [String] { get }
    var selectedFilterKeywordList: [FilterItemEntity]? { get }
    var isNeedToShowRefreshFilterCell: Bool { get }
    func didSelectFilter(_ filterEntity: FilterEntity?)
    func didTapRefreshFilterCell(store: ConvenienceStore?)
    func requestwithUpdatedKeywordFilter(with store: ConvenienceStore?)
    func initializeFilterState()
    func updateFiltersState(with filters: [FilterItemEntity], type: FilterType)
    func deleteKeywordFilter(_ filter: FilterItemEntity)
    func resetFilterState()
}
