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
            static let storeHeight: CGFloat = 44
            static let filterMargin: UIEdgeInsets = .init(top: 12, left: 15, bottom: 12, right: 15)
            static let filterHeight: CGFloat = 56
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
        
        let collectionStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            return stackView
        }()
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.bounces = false
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
        
        let filterCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.bounces = false
            collectionView.layoutMargins = Constant.Size.filterMargin
            return collectionView
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
            contentView.addSubview(collectionStackView)
            contentView.addSubview(productHomePageViewController.view)
            
            collectionStackView.addArrangedSubview(collectionView)
            collectionStackView.addArrangedSubview(filterCollectionView)
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
            
            collectionStackView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(titleNavigationView.snp.bottom)
            }
            
            collectionView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(.spacing16)
                make.height.equalTo(Constant.Size.storeHeight)
            }
            
            storeCollectionViewSeparator.snp.makeConstraints { make in
                make.height.equalTo(Constant.Size.storeCollectionViewSeparatorHeight)
                make.bottom.equalTo(collectionView.snp.bottom)
                make.leading.trailing.equalToSuperview()
            }
            
            filterCollectionView.snp.makeConstraints {
                $0.height.equalTo(Constant.Size.filterHeight)
                $0.top.equalTo(storeCollectionViewSeparator.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
            
            productHomePageViewController.view.snp.makeConstraints { make in
                make.top.equalTo(collectionStackView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}
