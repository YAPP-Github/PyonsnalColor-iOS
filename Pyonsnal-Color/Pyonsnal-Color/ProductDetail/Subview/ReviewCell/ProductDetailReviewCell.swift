//
//  ProductDetailReviewCell.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

final class ProductDetailReviewCell: UICollectionViewCell {
    
    // MARK: - Declaration
    struct Payload {
        let review: ReviewEntity
    }
    
    // MARK: - Interface
    var payload: Payload? {
        didSet { updateUI() }
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
    
    private func updateUI() {
        guard let payload else {
            return
        }
        
        let review = payload.review
        viewHolder.reviewMetaView.payload = .init(review: review)
        if let imageURL = review.image {
            viewHolder.reviewImageView.setImage(with: imageURL)
        }
        viewHolder.reviewTagListView.payload = .init(
            taste: review.taste,
            quality: review.quality,
            valueForMoney: review.valueForMoney
        )
        viewHolder.reviewLabel.text = review.contents
    }
}
