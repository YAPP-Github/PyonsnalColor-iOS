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
            static let leftRightMargin: CGFloat = 16
            static let headerTopInset: CGFloat = 11
            static let headerBottomInset: CGFloat = 11
        }
        
        enum Text {
            static let title: String = "차별화 상품 둘러보기"
            static let alertImageName: String = "bell"
        }
    }
    
    final class ViewHolder: ViewHolderable {
        let containerScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.bounces = false
            return scrollView
        }()
        
        private let contentView: UIView = {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            return view
        }()
        
        let headerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.layoutMargins = UIEdgeInsets(
                top: Constant.Size.headerTopInset,
                left: Constant.Size.leftRightMargin,
                bottom: Constant.Size.headerTopInset,
                right: Constant.Size.leftRightMargin
            )
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = Constant.Text.title
            label.font = UIFont.title2
            return label
        }()
        
        private let alertButton: UIButton = {
            let button = UIButton()
            button.setImage(.init(systemName: Constant.Text.alertImageName), for: .normal)
            button.tintColor = .black
            return button
        }()
        
        let convenienceStoreCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(ConvenienceStoreCell.self)
            collectionView.isScrollEnabled = false
            collectionView.layoutMargins = UIEdgeInsets(
                top: 0,
                left: Constant.Size.leftRightMargin,
                bottom: 0,
                right: Constant.Size.leftRightMargin
            )
            return collectionView
        }()
        
        let convenienceStorePageViewController: ConvenienceStorePageViewController = .init(
            pageCount: 5,
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        func place(in view: UIView) {
            view.addSubview(containerScrollView)
            containerScrollView.addSubview(contentView)
            
            contentView.addSubview(headerStackView)
            contentView.addSubview(convenienceStoreCollectionView)
            contentView.addSubview(convenienceStorePageViewController.view)
            
            headerStackView.addArrangedSubview(titleLabel)
            headerStackView.addArrangedSubview(alertButton)
        }
        
        func configureConstraints(for view: UIView) {
            containerScrollView.snp.makeConstraints { make in
                make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
                make.height.equalTo(view.snp.height)
            }
            
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
            
            headerStackView.snp.makeConstraints { make in
                make.leading.trailing.top.equalToSuperview()
            }
            
            convenienceStoreCollectionView.snp.makeConstraints { make in
                make.top.equalTo(headerStackView.snp.bottom)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(41)
            }
            
            convenienceStorePageViewController.view.snp.makeConstraints { make in
                make.top.equalTo(convenienceStoreCollectionView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}
