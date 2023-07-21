//
//  ProductSearchViewController+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import UIKit
import SnapKit

extension ProductSearchViewController {
    final class ViewHolder: ViewHolderable {
        // MARK: - Declaration
        enum Constant {
            enum Size {
                static let navigationBarBackgroundViewHeight: CGFloat = 48
                static let backButtonSize: CGFloat = 24
            }
        }
        // MARK: - UI Component
        private let contentView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        private let navigationBarBackgroundView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        let backButton: UIButton = {
            let button: UIButton = .init(frame: .zero)
            button.setImage(.iconBack, for: .normal)
            return button
        }()
        
        let searchBarView: SearchBarView = {
            let searchBarView: SearchBarView = .init()
            return searchBarView
        }()
        
        private let collectionView: UICollectionView = {
            let layout: UICollectionViewFlowLayout = .init()
            layout.scrollDirection = .vertical
            
            let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .yellow
            return collectionView
        }()
        
        // MARK: - Method
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(navigationBarBackgroundView)
            contentView.addSubview(collectionView)
            
            navigationBarBackgroundView.addSubview(backButton)
            navigationBarBackgroundView.addSubview(searchBarView)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalToSuperview()
            }
            
            navigationBarBackgroundView.snp.makeConstraints { make in
                make.height.equalTo(Constant.Size.navigationBarBackgroundViewHeight)
                make.top.leading.trailing.equalToSuperview()
            }
            
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(navigationBarBackgroundView.snp.bottom)
                make.leading.trailing.bottom.equalToSuperview()
            }
            
            backButton.snp.makeConstraints { make in
                make.size.equalTo(Constant.Size.backButtonSize)
                make.top.bottom.equalToSuperview().inset(.spacing12)
                make.leading.equalToSuperview().offset(.spacing16)
            }
            
            searchBarView.snp.makeConstraints { make in
                make.height.equalTo(32)
                make.leading.equalTo(backButton.snp.trailing).offset(.spacing12)
                make.top.equalToSuperview().offset(.spacing8)
                make.trailing.equalToSuperview().inset(.spacing12)
            }
        }
    }
}
