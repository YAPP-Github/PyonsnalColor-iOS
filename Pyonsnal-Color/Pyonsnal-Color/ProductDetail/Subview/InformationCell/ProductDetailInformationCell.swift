//
//  ProductDetailInformationCell.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

final class ProductDetailInformationCell: UICollectionViewCell {
    
    // MARK: - Declaration
    struct Payload {
        let productDetail: ProductDetailEntity
    }
    
    // MARK: - Interface
    var payload: Payload? {
        didSet { configure() }
    }
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func configureView() {
        viewHolder.place(in: contentView)
    }
    
    private func configureConstraint() {
        viewHolder.configureConstraints(for: contentView)
    }
    
    private func configure() {
        guard let payload else {
            return
        }
        
        if let name = payload.productDetail.giftTitle,
           let price = payload.productDetail.giftPrice,
           let imageURL = payload.productDetail.giftImageURL {
            viewHolder.giftInformationView.giftItem = .init(
                name: name,
                price: price,
                imageURL: imageURL
            )
        }
        let productDetail = payload.productDetail
        viewHolder.updateDateLabel.text = productDetail.updatedTime
        if let isNew = productDetail.isNew {
            viewHolder.productTagListView.isHidden = false
            viewHolder.productTagListView.payload = .init(
                isNew: isNew, eventTags: productDetail.eventType
            )
        } else {
            viewHolder.productTagListView.isHidden = true
        }
        viewHolder.productNameLabel.text = productDetail.name
        viewHolder.productPriceLabel.text = productDetail.price
        viewHolder.productDescriptionLabel.text = productDetail.description
    }
}
