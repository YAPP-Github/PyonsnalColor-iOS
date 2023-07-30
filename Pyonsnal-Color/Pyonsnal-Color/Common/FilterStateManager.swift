//
//  FilterStateManager.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/30.
//

import Foundation

final class FilterStateManager {
    private var filterDataEntity: FilterDataEntity
    private let latestSortFilterName = "최신순"
    init(filterDataEntity: FilterDataEntity) {
        self.filterDataEntity = filterDataEntity
    }
    
    /// 모든 filterItemEntity isSelected 값을 변경합니다.
    func updateAllFilterItemState(to isSelected: Bool) {
        filterDataEntity.data.forEach { filters in
            filters.filterItem.forEach {
                var filter = $0
                filter.isSelected = false
            }
            Log.d(message: "filter state \(filterDataEntity.data.map { _ in Log.d(message: "\(filters.filterItem)")})")
        }
        updateFilterDataState()
        setLastSortFilterSelected()
    }
    
    /// 한 filterItemEntity의 state 값을 변경합니다.
    func updateFilterItemState(target filterItem: FilterItemEntity, to isSelected: Bool) {
        // 처음 targetFilterItem selected 값을 변경
        var targetFilterItem = filterItem
        targetFilterItem.isSelected = isSelected
        
        for index in 0..<filterDataEntity.data.count {
            for secondIndex in 0..<filterDataEntity.data[index].filterItem.count {
                if filterDataEntity.data[index].filterItem[secondIndex].code == targetFilterItem.code {
                    filterDataEntity.data[index].filterItem[secondIndex].isSelected = targetFilterItem.isSelected
                    break
                }
            }
        }
        
        updateFilterDataState()
        Log.d(message: "filterDataEntity \(filterDataEntity)")
    }
    
    /// filterItemEntity 값 변경에 따라 FilterDataEntity isSelected 값을 업데이트 합니다.
    func updateFilterDataState() {
        filterDataEntity.data.forEach {
            var filters = $0
            let filterItem = filters.filterItem
            let isAllFilterItemSelected = filterItem.allSatisfy { $0.isSelected == true }
            filters.isSelected = isAllFilterItemSelected
            Log.d(message: "filterDataEntity \(filters.isSelected)")
        }
        
    }
    
    /// 최신순 filter의 isSelected 값을 true로 변경합니다.
    func setLastSortFilterSelected() {

        for (firstIndex, _) in filterDataEntity.data.enumerated() {
            if filterDataEntity.data[firstIndex].filterType == .sort {
                for (index, _) in filterDataEntity.data[firstIndex].filterItem.enumerated() {
                    if filterDataEntity.data[firstIndex].filterItem[index].name == latestSortFilterName {
                        filterDataEntity.data[firstIndex].filterItem[index].isSelected = true
                        break
                    }
                }
            }
        }
    }
    
    /// sortFilter의 defaultText 값을 설정합니다.
    func setSortFilterDefaultText() {
        filterDataEntity.data.forEach {
            var filters = $0
            if filters.filterType == .sort {
                filters.defaultText = filters.filterType.filterDefaultText
            }
        }
        
    }
    
    /// sort defaultText를 선택된 filter name으로 업데이트 합니다.
    func updateSortDefaultText() {
        let sortFilters = filterDataEntity.data.first { $0.filterType == .sort }
        guard var sortFilters else { return }
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
        // 예외 - 최신순의 경우 isSelected = true가 default 상태
        // 최신순 && 나머지 filter isSelected = false
        let isLatestSortFilter = filterDataEntity.data
            .first(where: { $0.filterType == .sort })?.filterItem
            .first(where: { $0.name == latestSortFilterName })
        let isLatestSortFilterSelected = isLatestSortFilter?.isSelected == true
        
        Log.d(message: "최신순 \(isLatestSortFilterSelected)")
        
        let filterItems = filterDataEntity.data.filter { $0.filterType != .sort }
        let isLastItemNotSelected = filterItems.allSatisfy { $0.isSelected == false }
        
        return !isLatestSortFilterSelected && isLastItemNotSelected
    }
    
}
