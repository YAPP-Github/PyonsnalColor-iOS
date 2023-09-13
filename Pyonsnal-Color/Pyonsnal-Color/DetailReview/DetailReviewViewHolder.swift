//
//  DetailReviewViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import UIKit
import SnapKit

extension DetailReviewViewController {
    final class ViewHolder: ViewHolderable {
        enum Constant {
            static let navigationTitle: String = "상품 리뷰 작성하기"
            
        }
        
        private let backNavigationView: BackNavigationView = {
            let navigationView = BackNavigationView()
            navigationView.payload = .init(
                mode: .text,
                title: Constant.navigationTitle,
                iconImageKind: nil
            )
            return navigationView
        }()
        
        private let totalScrollView = UIScrollView()
        
        private let productTotalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = .spacing16
            stackView.layoutMargins = .init(
                top: .spacing24,
                left: .spacing16,
                bottom: .spacing24,
                right: 0
            )
            
            return stackView
        }()
        
        private let productImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            return imageView
        }()
        
        private let productInformationStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing8
            stackView.alignment = .leading
            return stackView
        }()
        
        private let storeImageView = UIImageView()
        
        private let productNameLabel: UILabel = {
            let label = UILabel()
            label.font = .body3m
            label.numberOfLines = 1
            return label
        }()
        
        // TODO: 별점 뷰 추가
        
        private let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray100
            return view
        }()
        
        func place(in view: UIView) {
            
        }
        
        func configureConstraints(for view: UIView) {
            
        }
        
        
    }
}
