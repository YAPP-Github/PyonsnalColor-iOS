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
        
        let backNavigationView: BackNavigationView = {
            let backNavigationView = BackNavigationView()
            return backNavigationView
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
        private let productImageContainerView: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .white
            return view
        }()
        
        let productImageView: UIImageView = {
            let imageView: UIImageView = .init(frame: .zero)
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        // 중간 라인
        private let lineView: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .gray100
            return view
        }()
        
        // 상품 정보 뷰
        private let productInformationContainerView: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .white
            return view
        }()
        
        let updateDateLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.textColor = .gray400
            label.font = .body3r
            return label
        }()
        
        private let textInfoStackView: UIStackView = {
            let stackView = UIStackView(frame: .zero)
            stackView.axis = .vertical
            stackView.spacing = 16
            return stackView
        }()
        
        let productTagListView: ProductTagListView = {
            let productTagListView: ProductTagListView = .init()
            return productTagListView
        }()
        
        private let textContainerView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()
        
        let productNameLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.textColor = .gray700
            label.font = .title1
            return label
        }()
        
        let productPriceLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.textColor = .black
            label.font = .headLine
            return label
        }()
        
        let productDescriptionLabel: UILabel = {
            let label: UILabel = .init(frame: .zero)
            label.numberOfLines = 0
            label.textColor = .gray600
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
            
            contentView.addSubview(backNavigationView)
            contentView.addSubview(contentScrollView)
            
            contentScrollView.addSubview(contentStackView)
            
            contentStackView.addArrangedSubview(productImageContainerView)
            contentStackView.addArrangedSubview(lineView)
            contentStackView.addArrangedSubview(productInformationContainerView)
            
            productImageContainerView.addSubview(productImageView)
            
            productInformationContainerView.addSubview(updateDateLabel)
            productInformationContainerView.addSubview(textInfoStackView)
            
            textInfoStackView.addArrangedSubview(productTagListView)
            textInfoStackView.addArrangedSubview(textContainerView)
            
            textContainerView.addSubview(productNameLabel)
            textContainerView.addSubview(productPriceLabel)
            textContainerView.addSubview(productDescriptionLabel)
            textContainerView.addSubview(giftInformationView)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            backNavigationView.snp.makeConstraints { make in
                make.leading.top.trailing.equalToSuperview()
            }
            
            contentScrollView.snp.makeConstraints { make in
                make.top.equalTo(backNavigationView.snp.bottom)
                make.leading.bottom.trailing.equalToSuperview()
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
                make.top.trailing.equalToSuperview().inset(.spacing16)
            }
            
            textInfoStackView.snp.makeConstraints { make in
                make.top.equalTo(updateDateLabel.snp.bottom).offset(.spacing12)
                make.leading.bottom.trailing.equalToSuperview()
            }
            
            productTagListView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(.spacing16)
            }
            
            textContainerView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(.spacing16)
            }
            
            productNameLabel.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
            }
            
            productPriceLabel.snp.makeConstraints { make in
                make.top.equalTo(productNameLabel.snp.bottom).offset(.spacing4)
                make.leading.trailing.equalToSuperview()
            }
            
            productDescriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(productPriceLabel.snp.bottom).offset(.spacing16)
                make.leading.trailing.equalToSuperview()
            }
            
            giftInformationView.snp.makeConstraints { make in
                make.top.equalTo(productDescriptionLabel.snp.bottom).offset(40)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}
