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
        
        private let contentStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            return stackView
        }()
        
        private let productTotalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = .spacing16
            stackView.isLayoutMarginsRelativeArrangement = true
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
        
        private let reviewButtonStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing40
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = .init(
                top: .spacing24,
                left: .spacing16,
                bottom: 0,
                right: .spacing16
            )
            return stackView
        }()
        
        let tasteReview = SingleLineReview()
        let qualityReview = SingleLineReview()
        let priceReview = SingleLineReview()
        
        private let detailReviewStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing20
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = .init(
                top: 0,
                left: .spacing16,
                bottom: 0,
                right: .spacing16
            )
            return stackView
        }()
        
        let detailReviewLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            return label
        }()
        
        let detailReviewTextView: UITextView = {
            let textView = UITextView()
            textView.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            textView.textContainerInset = .init(
                top: .spacing12,
                left: .spacing12,
                bottom: .spacing12,
                right: .spacing12
            )
            textView.backgroundColor = .gray100
            textView.font = .body2r
            return textView
        }()
        
        private let imageUploadStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.spacing = .spacing20
            stackView.axis = .vertical
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = .init(
                top: 0,
                left: .spacing16,
                bottom: 0,
                right: .spacing16
            )
            return stackView
        }()
        
        private let imageUploadLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            return label
        }()
        
        private let imageUploadButton: UIButton = {
            let button = UIButton()
            button.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            button.backgroundColor = .gray100
            button.setImage(.init(systemName: "plus"), for: .normal)
            button.tintColor = .gray200
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(totalScrollView)
            
            totalScrollView.addSubview(contentStackView)
            
            contentStackView.addArrangedSubview(productTotalStackView)
            contentStackView.addArrangedSubview(separatorView)
            contentStackView.addArrangedSubview(reviewButtonStackView)
            contentStackView.addArrangedSubview(detailReviewStackView)
            contentStackView.addArrangedSubview(imageUploadStackView)
            
            productTotalStackView.addArrangedSubview(productImageView)
            productTotalStackView.addArrangedSubview(productInformationStackView)
            
            productInformationStackView.addArrangedSubview(storeImageView)
            productInformationStackView.addArrangedSubview(productNameLabel)
            // TODO: 별점 뷰 추가
            
            reviewButtonStackView.addArrangedSubview(tasteReview)
            reviewButtonStackView.addArrangedSubview(qualityReview)
            reviewButtonStackView.addArrangedSubview(priceReview)
            
            detailReviewStackView.addArrangedSubview(detailReviewLabel)
            detailReviewStackView.addArrangedSubview(detailReviewTextView)
            
            imageUploadStackView.addArrangedSubview(imageUploadLabel)
            imageUploadStackView.addArrangedSubview(imageUploadButton)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            totalScrollView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalTo(view)
                $0.top.equalTo(backNavigationView.snp.bottom)
            }
            
            contentStackView.snp.makeConstraints {
                $0.width.equalToSuperview()
            }
            
            productTotalStackView.snp.makeConstraints {
                $0.leading.top.trailing.equalToSuperview()
            }
            
            separatorView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(productTotalStackView.snp.bottom)
                $0.height.equalTo(12)
            }
            
            reviewButtonStackView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(separatorView.snp.bottom)
            }
            
            detailReviewStackView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(reviewButtonStackView.snp.bottom).offset(60)
            }
            
            detailReviewTextView.snp.makeConstraints {
                $0.height.equalTo(200)
            }
            
            imageUploadStackView.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.bottom.equalToSuperview().inset(152)
                $0.top.equalTo(detailReviewStackView.snp.bottom).offset(40)
            }
            
            imageUploadButton.snp.makeConstraints {
                $0.width.height.equalTo(120)
            }
        }
        
    }
}
