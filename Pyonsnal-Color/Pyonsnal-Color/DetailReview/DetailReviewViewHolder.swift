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
            
            static let tasteReviewTitle: String = "상품의 맛은 어떤가요?"
            static let tasteGood: String = "맛있어요"
            static let tasteOkay: String = "보통이예요"
            static let tasteBad: String = "별로예요"
            
            static let qualityReviewTitle: String = "상품의 퀄리티는 어떤가요?"
            static let qualityGood: String = "좋아요"
            static let qualityOkay: String = "보통이예요"
            static let qualityBad: String = "별로예요"
            
            static let priceReviewTitle: String = "상품의 가격은 어떤가요?"
            static let priceGood: String = "합리적이예요"
            static let priceOkay: String = "적당해요"
            static let priceBad: String = "비싸요"
            
            static let detailReviewTitle: String = "좀 더 자세하게 알려주세요!"
            static let detailReviewPlaceholder: String = "상품에 대한 솔직한 의견을 알려주세요."
            
            static let imageUploadTitle: String = "사진 업로드"
            
            static let applyReviewTitle: String = "작성 완료"
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
        
        let tasteReview: SingleLineReview = {
            let review = SingleLineReview(category: .taste)
            review.configureReviewTitle(
                title: Constant.tasteReviewTitle,
                first: Constant.tasteGood,
                second: Constant.tasteOkay,
                third: Constant.tasteBad
            )
            return review
        }()
        
        let qualityReview: SingleLineReview = {
            let review = SingleLineReview(category: .quality)
            review.configureReviewTitle(
                title: Constant.qualityReviewTitle,
                first: Constant.qualityGood,
                second: Constant.qualityOkay,
                third: Constant.qualityBad
            )
            return review
        }()
        
        let priceReview: SingleLineReview = {
            let review = SingleLineReview(category: .price)
            review.configureReviewTitle(
                title: Constant.priceReviewTitle,
                first: Constant.priceGood,
                second: Constant.priceOkay,
                third: Constant.priceBad
            )
            return review
        }()
        
        private let detailReviewStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing20
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = .init(
                top: 60,
                left: .spacing16,
                bottom: .spacing40,
                right: .spacing16
            )
            return stackView
        }()
        
        let detailReviewLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            label.text = Constant.detailReviewTitle
            return label
        }()
        
        let detailReviewTextView: UITextView = {
            let textView = UITextView()
            textView.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            textView.makeRounded(with: .spacing16)
            textView.textContainerInset = .init(
                top: .spacing12,
                left: .spacing12,
                bottom: .spacing12,
                right: .spacing12
            )
            textView.backgroundColor = .gray100
            textView.font = .body2r
            textView.textColor = .gray400
            return textView
        }()
        
        private let imageUploadStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.alignment = .leading
            stackView.spacing = .spacing20
            stackView.axis = .vertical
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = .init(
                top: 0,
                left: .spacing16,
                bottom: 152,
                right: .spacing16
            )
            return stackView
        }()
        
        let imageUploadLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            label.text = Constant.imageUploadTitle
            return label
        }()
        
        let imageUploadButton: UIButton = {
            let button = UIButton()
            button.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            button.makeRounded(with: .spacing16)
            button.backgroundColor = .gray100
            button.setImage(.init(systemName: "plus"), for: .normal)
            button.tintColor = .gray400
            return button
        }()
        
        let deleteImageButton: UIButton = {
            let button = UIButton()
            button.setImage(.iconDeleteMedium, for: .normal)
            button.isHidden = true
            return button
        }()
        
        let applyReviewButton: PrimaryButton = {
            let button = PrimaryButton(state: .disabled)
            button.setText(with: Constant.applyReviewTitle)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(totalScrollView)
            
            totalScrollView.addSubview(contentStackView)
            totalScrollView.addSubview(applyReviewButton)
            
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
            
            imageUploadButton.addSubview(deleteImageButton)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            totalScrollView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
                $0.top.equalTo(backNavigationView.snp.bottom)
            }
            
            contentStackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.greaterThanOrEqualToSuperview()
            }
            
            applyReviewButton.snp.makeConstraints {
                $0.bottom.equalTo(totalScrollView.frameLayoutGuide)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(52)
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
            }
            
            detailReviewTextView.snp.makeConstraints {
                $0.height.equalTo(200)
            }
            
            imageUploadStackView.snp.makeConstraints {
                $0.leading.equalToSuperview()
            }
            
            imageUploadButton.snp.makeConstraints {
                $0.width.height.equalTo(120)
            }
            
            deleteImageButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(6)
                $0.trailing.equalToSuperview().inset(6)
            }
        }
    }
}
