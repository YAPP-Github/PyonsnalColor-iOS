//
//  ProductDetailViewController+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import UIKit
import SnapKit

extension ProductDetailViewController {
    final class ViewHolder: ViewHolderable {
        // MARK: - UI Component
        private let contentView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        private let contentScrollView: UIScrollView = {
            let scrollView: UIScrollView = .init(frame: .zero)
            scrollView.backgroundColor = .white
            return scrollView
        }()
        
        private let contentStackView: UIStackView = {
            let stackView: UIStackView = .init(frame: .zero)
            stackView.axis = .vertical
            return stackView
        }()
        
        // 상품 이미지 뷰
        private let productImageBackgroundView: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .white
            return view
        }()
        
        private let productImageView: UIImageView = {
            let imageView: UIImageView = .init(frame: .zero)
            imageView.backgroundColor = .yellow
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        // 중간 라인
        private let lineView: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .init(hexCode: "#F7F7F9")
            return view
        }()
        
        // 상품 정보 뷰
        private let productInformationBackgroundView: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .white
            return view
        }()
        
        let updateDateLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.textColor = .init(hexCode: "#B3B3B6")
            label.font = .body3r
            return label
        }()
        
        private let textInfoStackView: UIStackView = {
            let stackView = UIStackView(frame: .zero)
            stackView.axis = .vertical
            stackView.spacing = 16
            return stackView
        }()
        
        private let productTagListView: ProductTagListView = {
            let productTagListView: ProductTagListView = .init(frame: .zero)
            return productTagListView
        }()
        
        private let textBackgroundView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        let productNameLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.textColor = .init(hexCode: "#343437")
            label.font = .title1
            return label
        }()
        
        let productPriceLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.textColor = .init(hexCode: "#1A1A1E")
            label.font = .headLine
            return label
        }()
        
        let productDescriptionLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.textColor = .init(hexCode: "#4D4D51")
            label.font = .body2r
            return label
        }()
        
        let giftInformationView: GiftInformationView = {
            let giftInformationView: GiftInformationView = .init()
            return giftInformationView
        }()
        
        // MARK: - Method
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(contentScrollView)
            
            contentScrollView.addSubview(contentStackView)
            
            contentStackView.addArrangedSubview(productImageBackgroundView)
            contentStackView.addArrangedSubview(lineView)
            contentStackView.addArrangedSubview(productInformationBackgroundView)
            
            productImageBackgroundView.addSubview(productImageView)
            
            productInformationBackgroundView.addSubview(updateDateLabel)
            productInformationBackgroundView.addSubview(textInfoStackView)
            
            textInfoStackView.addArrangedSubview(productTagListView)
            textInfoStackView.addArrangedSubview(textBackgroundView)
            
            textBackgroundView.addSubview(productNameLabel)
            textBackgroundView.addSubview(productPriceLabel)
            textBackgroundView.addSubview(productDescriptionLabel)
            textBackgroundView.addSubview(giftInformationView)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            contentScrollView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            contentStackView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.edges.equalToSuperview()
            }
            
            productImageView.snp.makeConstraints { make in
                make.size.equalTo(200)
                make.top.bottom.equalToSuperview().inset(60)
                make.centerX.equalToSuperview()
            }
            
            lineView.snp.makeConstraints { make in
                make.height.equalTo(12)
            }
            
            updateDateLabel.snp.makeConstraints { make in
                make.top.trailing.equalToSuperview().inset(16)
            }
            
            textInfoStackView.snp.makeConstraints { make in
                make.top.equalTo(updateDateLabel.snp.bottom).offset(12)
                make.leading.bottom.trailing.equalToSuperview()
            }
            
            productTagListView.snp.makeConstraints { make in
                make.height.equalTo(24)
                make.leading.trailing.equalToSuperview().inset(16)
            }
            
            textBackgroundView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
            }
            
            productNameLabel.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
            }
            
            productPriceLabel.snp.makeConstraints { make in
                make.top.equalTo(productNameLabel.snp.bottom).offset(4)
                make.leading.trailing.equalToSuperview()
            }
            
            productDescriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(productPriceLabel.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview()
            }
            
            giftInformationView.snp.makeConstraints { make in
                make.top.equalTo(productDescriptionLabel.snp.bottom).offset(40)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}
