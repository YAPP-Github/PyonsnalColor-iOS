//
//  ProductCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/14.
//

import UIKit
import SnapKit

final class ProductCell: UICollectionViewCell {
    
    enum Size {
        // TO DO : component margin 정리 주시면 CommonMarginManager로 분리 예정
        static let dividerMargin: CGFloat = 12
        static let productImageViewMargin: CGFloat = 25.5
        static let convenientTagImageViewMargin: CGFloat = 12
        static let tagImageViewMargin: CGFloat = 12
        static let newImageViewMargin: CGFloat = 12
        static let titleLabelLeading: CGFloat = 4
        static let titleLabelMargin: CGFloat = 12
        static let priceContainerViewTop: CGFloat = 4
        static let priceContainerViewMargin: CGFloat = 12
        static let discountPriceLabelLeading: CGFloat = 4
        
        static let dividerHeight: CGFloat = 1
        static let productImageContainerViewHeight: CGFloat = 171
        static let convenientTagImageViewWidth: CGFloat = 36
        static let eventTagImageViewWidth: CGFloat = 38
        static let eventTagImageViewHeight: CGFloat = 20
        static let newImageViewWidth: CGFloat = 28
        static let priceContainerViewHeight: CGFloat = 64
        static let eventTagImageviewRadius: CGFloat = 10
        static let cornerRadius: CGFloat = 16
    }
    
    private let viewHolder: ViewHolder = .init()
    
    final class ViewHolder: ViewHolderable {
        
        // MARK: - UI Component
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.backgroundColor = .white
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 0
            return stackView
        }()
        
        let productImageContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let itemImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let dividerView: UIView = {
            let dividerView = UIView()
            dividerView.backgroundColor = .gray100
            return dividerView
        }()
        
        let itemInfoContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let newTagView = NewTagView(mode: .small)
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body4m
            label.numberOfLines = 1
            label.lineBreakMode = .byTruncatingTail
            return label
        }()
        
        let priceContainerView: UIView = {
            let view = UIView()
            return view
        }()
        
        let originalPriceLabel: UILabel = {
            let label = UILabel()
            label.font = .body3m
            return label
        }()
        
        let discountPriceLabel: UILabel = {
            let label = UILabel()
            label.font = .body4r
            return label
        }()
        
        let convenienceStoreTagImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .blue
            return imageView
        }()
        
        let eventTagLabel: UILabel = {
            let label = UILabel()
            label.makeRounded(with: Spacing.spacing20.value)
            label.backgroundColor = .green500
            label.font = .body4m
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()
        
        // MARK: - Method
        func place(in view: UIView) {
            view.addSubview(stackView)
            
            stackView.addArrangedSubview(productImageContainerView)
            stackView.addArrangedSubview(dividerView)
            stackView.addArrangedSubview(itemInfoContainerView)
            
            productImageContainerView.addSubview(itemImageView)
            productImageContainerView.addSubview(convenienceStoreTagImageView)
            productImageContainerView.addSubview(eventTagLabel)
            
            itemInfoContainerView.addSubview(newTagView)
            itemInfoContainerView.addSubview(titleLabel)
            itemInfoContainerView.addSubview(priceContainerView)
            
            priceContainerView.addSubview(originalPriceLabel)
            priceContainerView.addSubview(discountPriceLabel)
        }
        
        func configureConstraints(for view: UIView) {
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            productImageContainerView.snp.makeConstraints {
                $0.width.equalTo(stackView.snp.width)
                $0.height.equalTo(Size.productImageContainerViewHeight)
            }
            
            dividerView.snp.makeConstraints {
                $0.leading.equalTo(Size.dividerMargin)
                $0.height.equalTo(Size.dividerHeight)
            }
            
            itemImageView.snp.makeConstraints {
                $0.top.leading.equalToSuperview().offset(Size.productImageViewMargin)
                $0.trailing.bottom.equalToSuperview().inset(Size.productImageViewMargin)
            }
            
            convenienceStoreTagImageView.snp.makeConstraints {
                $0.top.leading.equalToSuperview().inset(Size.convenientTagImageViewMargin)
                $0.width.height.equalTo(Size.convenientTagImageViewWidth)
            }
            
            eventTagLabel.snp.makeConstraints {
                $0.trailing.bottom.equalToSuperview().inset(Size.tagImageViewMargin)
                $0.width.equalTo(Size.eventTagImageViewWidth)
                $0.height.equalTo(Size.eventTagImageViewHeight)
            }
            
            itemInfoContainerView.snp.makeConstraints {
                $0.leading.equalTo(stackView)
            }
            
            newTagView.snp.makeConstraints {
                $0.leading.top.equalToSuperview().offset(Size.newImageViewMargin)
                $0.width.equalTo(Size.newImageViewWidth)
                $0.centerY.equalTo(titleLabel)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(Size.titleLabelMargin)
                $0.leading.equalTo(newTagView.snp.trailing).offset(Size.titleLabelLeading)
                $0.trailing.lessThanOrEqualTo(-Size.titleLabelMargin)
                $0.height.equalTo(titleLabel.font.customLineHeight)
            }
            
            priceContainerView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(Size.priceContainerViewTop)
                $0.leading.trailing.bottom.equalToSuperview().inset(Size.priceContainerViewMargin)
            }
            
            originalPriceLabel.snp.contentHuggingHorizontalPriority = 251
            discountPriceLabel.snp.contentHuggingHorizontalPriority = 250
            
            originalPriceLabel.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
            }
            
            discountPriceLabel.snp.makeConstraints {
                $0.leading.equalTo(originalPriceLabel.snp.trailing).offset(Size.discountPriceLabelLeading)
                $0.top.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let attributedText = viewHolder.discountPriceLabel.text?.strikeThrough(with: .gray500)
        viewHolder.discountPriceLabel.attributedText = attributedText
        self.makeRounded(with: Size.cornerRadius)
        viewHolder.convenienceStoreTagImageView.makeRounded(with: Size.convenientTagImageViewWidth / 2)
        viewHolder.eventTagLabel.makeRounded(with: Size.eventTagImageviewRadius)
    }
    
    func updateCell(with product: ProductConvertable) {
        viewHolder.titleLabel.text = product.name
        if let storeTypeImage = product.storeType.storeTagImage {
            viewHolder.convenienceStoreTagImageView.setImage(storeTypeImage)
        }
        viewHolder.itemImageView.setImage(with: product.imageURL)
        viewHolder.originalPriceLabel.text = product.price.addWon()
        viewHolder.newTagView.isHidden = !product.isNew
        hasEventType(product.eventType)
    }
    
    private func hasEventType(_ event: EventTag?) {
        if let event {
            viewHolder.eventTagLabel.text = event.name
        } else {
            viewHolder.eventTagLabel.isHidden = true
        }
    }
}
