//
//  FilterStateManager.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/30.
//

import Foundation

final class FilterStateManager {
    private let filterDataEntity: FilterDataEntity
    
    init(filterDataEntity: FilterDataEntity) {
        self.filterDataEntity = filterDataEntity
    }
    
    /// 모든 filterItemEntity isSelected 값을 변경합니다.
    func setFilterItemState(with filterItem: [FilterItemEntity], to isSelected: Bool) {
        filterDataEntity.data.forEach { filters in
            filters.filterItem.forEach {
                var filter = $0
                filter.isSelected = false
            }
        }
        updateFilterDataState()
        Log.d(message: "filter state \(filterItem)")
    }
    
    /// 한 filterItemEntity의 state 값을 변경합니다.
    func updateFilterItemState(target filterItem: FilterItemEntity, to isSelected: Bool) {
        // 처음 targetFilterItem selected 값을 변경
        var targetFilterItem = filterItem
        targetFilterItem.isSelected = isSelected
        
        filterDataEntity.data.forEach {
            var filters = $0
            filters.filterItem.forEach {
                var filterItem = $0
                if filterItem.code == targetFilterItem.code {
                    filterItem = targetFilterItem
                }
            }
        }
        updateFilterDataState()
        Log.d(message: "filterDataEntity \(filterDataEntity)")
    }
    
    /// filterItemEntity 값 변경에 따라 FilterDataEntity isSelected 값을 업데이트 합니다.
    func updateFilterDataState() {
        filterDataEntity.data.forEach { filters in
            let filterItem = filters.filterItem
            let isAllFilterItemSelected = filterItem.allSatisfy { $0.isSelected == true }
            filters.isSelected = isAllFilterItemSelected
        }
        Log.d(message: "filterDataEntity \(filterDataEntity)")
    }
    
    /// sort defaultText를 선택된 filter name으로 업데이트 합니다.
    func updateSortDefaultText() {
        let sortFilters = filterDataEntity.data.first { $0.filterType == .sort }
        guard let sortFilters else { return }
        sortFilters.filterItem.forEach {
            var filter = $0
            if filter.isSelected {
                sortFilters.defaultText = filter.name
            }
        }
        Log.d(message: "sortFilters \(sortFilters)")
    }
    
    /// 현재 filterDataEntity를 리턴합니다.
    func getFilterDataEntity() -> FilterDataEntity {
        return filterDataEntity
    }
    
    /// 현재 filterEntity의 상태값을 리턴합니다.
    /// 각 필터 cell UI selected 상태 표현을 위한 용도
    func isFilterEntityIsSelected(target filterEntity: FilterEntity) -> Bool {
        let targetFilterEntity = filterDataEntity.data
            .first(where: { $0.filterType == filterEntity.filterType })
        return targetFilterEntity?.isSelected ?? false
    }
    
    /// filterData가 모두 isSelected = false인지 확인합니다
    /// refreshFilterCell show / hide 용도
    func isFilterDataResetState() -> Bool {
        return filterDataEntity.data.allSatisfy { $0.isSelected == false }
    }
    
}
