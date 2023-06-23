//
//  EventHomeSectionLayout.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/17.
//

import UIKit

final class EventHomeSectionLayout {
    
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
        
        enum Tab {
            static let width: CGFloat = 80
            static let height: CGFloat = 44
            static let inset: CGFloat = 10
        }
        
        static let topMargin: CGFloat = 8
        static let bottomMargin: CGFloat = 20
    }
    
    
    func eventLayout() -> NSCollectionLayoutSection {
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
        section.boundarySupplementaryItems = createSupplementaryView()
        return section
    }
    
    private func itemLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(Size.Item.width), heightDimension: .fractionalHeight(1.0))
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
        section.boundarySupplementaryItems = createSupplementaryView()
        return section
    }
    
    
    private func createSupplementaryView() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                           heightDimension: .absolute(Size.Header.height)),
                                                                        elementKind: ItemHeaderTitleView.className, alignment: .top)
        return [sectionHeader]
    }
}

extension EventHomeSectionLayout {
    func tabLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(Size.Tab.width),
                                               heightDimension: .estimated(Size.Tab.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: .zero,
                                                        leading: Size.Tab.inset,
                                                        bottom: .zero,
                                                        trailing: Size.Tab.inset)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func itemContainerLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(Size.Item.inset)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}

extension EventHomeSectionLayout {
    
    func section(at type: EventHomeTabViewController.SectionType) -> NSCollectionLayoutSection {
        switch type {
        case .event:
            return eventLayout()
        case .item:
            return itemLayout()
        }
    }
}
