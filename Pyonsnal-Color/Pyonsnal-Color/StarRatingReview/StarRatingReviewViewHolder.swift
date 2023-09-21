//
//  StarRatingReviewViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import UIKit
import SnapKit

extension StarRatingReviewViewController {
    final class ViewHolder: ViewHolderable {
        enum Constant {
            static let navigationTitle: String = "상품 리뷰 작성하기"
            static let mainTitle: String = "이 상품에 만족하셨나요?"
            
            static let titleSpacing: CGFloat = 100
            static let productSpacing: CGFloat = 40
            static let starRatingSpacing: CGFloat = 60
        }
        
        let backNavigationView: BackNavigationView = {
            let navigationView = BackNavigationView()
            navigationView.payload = .init(
                mode: .text,
                title: Constant.navigationTitle,
                iconImageKind: nil
            )
            navigationView.setText(with: Constant.navigationTitle)
            return navigationView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            label.text = Constant.mainTitle
            return label
        }()
        
        private let productStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing12
            stackView.alignment = .center
            return stackView
        }()
        
        let storeImageView = UIImageView()
        let productImageView = UIImageView()
        let productNameLabel: UILabel = {
            let label = UILabel()
            label.font = .body2m
            return label
        }()
        
        // TODO: 별점 리뷰 뷰 추가
        let starRatingView: PrimaryButton = {
            let button = PrimaryButton(state: .enabled)
            button.setText(with: "상세 리뷰")
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(titleLabel)
            view.addSubview(productStackView)
            view.addSubview(starRatingView)
            
            productStackView.addArrangedSubview(storeImageView)
            productStackView.addArrangedSubview(productImageView)
            productStackView.addArrangedSubview(productNameLabel)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom).offset(Constant.titleSpacing)
                $0.centerX.equalToSuperview()
            }
            
            productStackView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.productSpacing)
                $0.centerX.equalToSuperview()
            }
            
            starRatingView.snp.makeConstraints {
                $0.top.equalTo(productStackView.snp.bottom).offset(Constant.starRatingSpacing)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(200)
                $0.height.equalTo(40)
            }
        }
    }
}
