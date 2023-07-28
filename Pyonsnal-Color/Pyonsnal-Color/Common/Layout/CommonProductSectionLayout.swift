//
//  CommonProductSectionLayout.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/17.
//

import UIKit

final class CommonProductSectionLayout {
    
    enum Size {
        enum Event {
            static let width: CGFloat = 358
            static let height: CGFloat = 184
            static let inset: CGFloat = 16
        }
        
        enum Item {
            static let width: CGFloat = 171
            static let height: CGFloat = 235
            static let inset: CGFloat = 16
            static let bottomMargin: CGFloat = 42
        }
        
        enum Header {
            static let height: CGFloat = 32
        }
        
        enum KeywordFilter {
            static let estimatedWidth: CGFloat = 96
            static let height: CGFloat = 32
        }
        
        static let topMargin: CGFloat = 8
        static let bottomMargin: CGFloat = 20
    }
    
    private func keywordFilterLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Size.KeywordFilter.estimatedWidth),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Size.KeywordFilter.height)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(.spacing4)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 0,
            leading: .spacing16,
            bottom: .spacing24,
            trailing: 0
        )
        return section
    }
    
    private func eventLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(Size.Event.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: Size.Event.inset,
                                                      bottom: 0,
                                                      trailing: Size.Event.inset)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: Size.topMargin,
                                                        leading: 0,
                                                        bottom: Size.bottomMargin,
                                                        trailing: 0)
        section.boundarySupplementaryItems = createEventSupplementaryView()
        return section
    }
    
    private func itemLayout(from tab: CommonProductSectionLayout.Tab) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(Size.Item.width),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(Size.Item.height))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                      leading: Size.Item.inset,
                                                      bottom: 0,
                                                      trailing: Size.Item.inset)
        group.interItemSpacing = .fixed(Size.Item.inset)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Size.Item.inset
        section.contentInsets = NSDirectionalEdgeInsets(top: Size.topMargin,
                                                        leading: 0,
                                                        bottom: Size.Item.bottomMargin,
                    
                                                        trailing: 0)
        if tab == .home {
            section.boundarySupplementaryItems = createHomeSupplementaryView()
        } else if tab == .event {
            section.boundarySupplementaryItems = createEventSupplementaryView()
        }
        
        return section
    }
    
    private func createEventSupplementaryView() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(Size.Header.height)),
            elementKind: ItemHeaderTitleView.className,
            alignment: .top
        )
        return [sectionHeader]
    }
    
    private func createHomeSupplementaryView() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Size.Header.height)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return [sectionHeader]
    }
}

extension CommonProductSectionLayout {
    enum Tab {
        case home
        case event
    }
    func section(at type: EventHomeTabViewController.SectionType) -> NSCollectionLayoutSection {
        switch type {
        case .keywordFilter:
            return keywordFilterLayout()
        case .event:
            return eventLayout()
        case .item:
            return itemLayout(from: .event)
        }
    }
    
    func section(at type: ProductListViewController.SectionType) -> NSCollectionLayoutSection {
        switch type {
        case .keywordFilter:
            return keywordFilterLayout()
        case .product:
            return itemLayout(from: .home)
        }
    }
}
