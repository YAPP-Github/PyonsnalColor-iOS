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
        private let contentView: UIView = {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            return view
        }()
        
        private let headerStackView: UIStackView = {
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
            collectionView.register(
                ConvenienceStoreCell.self,
                forCellWithReuseIdentifier: ConvenienceStoreCell.identifier
            )
            collectionView.isScrollEnabled = false
            collectionView.layoutMargins = UIEdgeInsets(
                top: 0,
                left: Constant.Size.leftRightMargin,
                bottom: 0,
                right: Constant.Size.leftRightMargin
            )
            return collectionView
        }()
        
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(headerStackView)
            contentView.addSubview(convenienceStoreCollectionView)
            
            headerStackView.addArrangedSubview(titleLabel)
            headerStackView.addArrangedSubview(alertButton)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            headerStackView.snp.makeConstraints { make in
                make.leading.trailing.top.equalToSuperview()
            }
            
            convenienceStoreCollectionView.snp.makeConstraints { make in
                make.top.equalTo(headerStackView.snp.bottom)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(44)
            }
        }
    }
}
