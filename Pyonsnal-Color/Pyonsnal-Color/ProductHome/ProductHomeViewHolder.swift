//
//  ProductHomeViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/21.
//

import UIKit
import SnapKit

extension ProductHomeViewController {
    enum Constant {
        enum Size {
            static let backNavigationBarHeight: CGFloat = 48
            static let leftRightMargin: CGFloat = 16
            static let storeCollectionViewSeparatorHeight: CGFloat = 1
        }
        
        enum Text {
            static let title: String = "차별화 상품 둘러보기"
            static let notificationImageName: String = "bell"
        }
    }
    
    final class ViewHolder: ViewHolderable {
        let containerScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.bounces = false
            return scrollView
        }()
        
        private let contentView: UIView = {
            let view = UIView(frame: .zero)
            view.backgroundColor = .white
            return view
        }()
        
        let titleNavigationView = TitleNavigationView()
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.layoutMargins = UIEdgeInsets(
                top: 0,
                left: Constant.Size.leftRightMargin,
                bottom: 0,
                right: Constant.Size.leftRightMargin
            )
            return collectionView
        }()
        
        let storeCollectionViewSeparator: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .gray200
            return view
        }()
        
        let productHomePageViewController: ProductHomePageViewController = .init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        func place(in view: UIView) {
            view.addSubview(containerScrollView)
            containerScrollView.addSubview(contentView)
            
            contentView.addSubview(titleNavigationView)
            contentView.addSubview(storeCollectionViewSeparator)
            contentView.addSubview(collectionView)
            contentView.addSubview(productHomePageViewController.view)
        }
        
        func configureConstraints(for view: UIView) {
            containerScrollView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
            
            titleNavigationView.snp.makeConstraints { make in
                make.height.equalTo(Constant.Size.backNavigationBarHeight)
                make.leading.trailing.top.equalToSuperview()
            }
            
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(titleNavigationView.snp.bottom)
                make.leading.trailing.equalToSuperview().inset(.spacing16)
                let height = TopCommonSectionLayout.ConvenienceStore.height + TopCommonSectionLayout.Filter.height
                make.height.equalTo(height)
            }
            
            storeCollectionViewSeparator.snp.makeConstraints { make in
                make.height.equalTo(Constant.Size.storeCollectionViewSeparatorHeight)
                make.top.equalTo(collectionView.snp.bottom).inset(1)
                make.leading.trailing.equalToSuperview()
            }
            
            productHomePageViewController.view.snp.makeConstraints { make in
                make.top.equalTo(storeCollectionViewSeparator.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}
