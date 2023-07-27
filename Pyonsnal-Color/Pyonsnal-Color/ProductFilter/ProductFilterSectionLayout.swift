//
//  ProductFilterSectionLayout.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/25.
//

import UIKit

final class ProductFilterSectionLayout {
    
    enum Size {
        static let sortCellHeight: CGFloat = 40
        static let eventCellHeight: CGFloat = 40
        static let categoryCellHeight: CGFloat = 108
    }
    
    private func createSortSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Size.sortCellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Spacing.spacing12.value
        return section
    }
    
    private func createEventSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Size.eventCellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(Spacing.spacing12.value)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createCategorySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Size.categoryCellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(Spacing.spacing24.value)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createRecommendationSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Size.categoryCellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(Spacing.spacing24.value)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension ProductFilterSectionLayout {
    func section(at section: ProductFilterViewController.Section) -> NSCollectionLayoutSection {
        switch section {
        case .sort:
            return createSortSection()
        case .event:
            return createEventSection()
        case .category, .recommendation:
            return createCategorySection()
        }
    }
}
