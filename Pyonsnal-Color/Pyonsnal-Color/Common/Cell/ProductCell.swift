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
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 0
            return stackView
        }()
        
        let productImageContainerView: UIView = {
            let view = UIView()
            //TO DO : fix color
            view.backgroundColor = .white
            return view
        }()
        
        let itemImageView: UIImageView = {
            let imageView = UIImageView()
            //TO DO : fix color
            imageView.backgroundColor = .brown
            return imageView
        }()
        
        let dividerView: UIView = {
            let dividerView = UIView()
            //TO DO : fix color
            dividerView.backgroundColor = .black
            return dividerView
        }()
        
        let itemInfoContainerView: UIView = {
            let view = UIView()
            //TO DO : fix color
            view.backgroundColor = .white
            return view
        }()
        
        let newImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.setImage(.tagNew)
            return imageView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "산리오)햄치즈에그모닝머핀ddd"
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
            label.text = "2,900".addWon()
            return label
        }()
        
        let discountPriceLabel: UILabel = {
            let label = UILabel()
            label.font = .body4r
            label.text = "2,000".addWon()
            return label
        }()
        
        let convenienceStoreTagImageView: UIImageView = {
            let imageView = UIImageView()
            //TO DO : fix color
            imageView.setImage(.emart24)
            imageView.backgroundColor = .blue
            return imageView
        }()
        
        let eventTagImageView: UIImageView = {
            let imageView = UIImageView()
            //TO DO : fix color
            imageView.backgroundColor = .darkGray
            return imageView
        }()
        
        // MARK: - Method
        func place(in view: UIView) {
            view.addSubview(stackView)
            
            stackView.addArrangedSubview(productImageContainerView)
            stackView.addArrangedSubview(dividerView)
            stackView.addArrangedSubview(itemInfoContainerView)
            
            productImageContainerView.addSubview(itemImageView)
            productImageContainerView.addSubview(convenienceStoreTagImageView)
            productImageContainerView.addSubview(eventTagImageView)
            
            itemInfoContainerView.addSubview(newImageView)
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
            
            eventTagImageView.snp.makeConstraints {
                $0.trailing.bottom.equalToSuperview().inset(Size.tagImageViewMargin)
                $0.width.equalTo(Size.eventTagImageViewWidth)
                $0.height.equalTo(Size.eventTagImageViewHeight)
            }
            
            newImageView.snp.makeConstraints {
                $0.leading.top.equalToSuperview().offset(Size.newImageViewMargin)
                $0.width.equalTo(Size.newImageViewWidth)
                $0.bottom.equalTo(priceContainerView.snp.top)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(Size.titleLabelMargin)
                $0.leading.equalTo(newImageView.snp.trailing).offset(Size.titleLabelLeading)
                $0.trailing.lessThanOrEqualTo(-Size.titleLabelMargin)
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
        self.makeRounded(with: Size.cornerRadius)
        //TO DO : fix color
        viewHolder.discountPriceLabel.attributedText = viewHolder.discountPriceLabel.text?.strikeThrough(with: .black)
        viewHolder.convenienceStoreTagImageView.makeRounded(with: Size.convenientTagImageViewWidth / 2)
        viewHolder.eventTagImageView.makeRounded(with: Size.eventTagImageviewRadius)
    }
}
