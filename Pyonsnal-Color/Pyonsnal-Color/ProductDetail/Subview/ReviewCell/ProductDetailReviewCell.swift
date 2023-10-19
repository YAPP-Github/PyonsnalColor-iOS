//
//  ProductDetailReviewCell.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

protocol ProductDetailReviewCellDelegate: AnyObject {
    func goodButtonDidTap(review: ReviewEntity)
    func badButtonDidTap(review: ReviewEntity)
}

final class ProductDetailReviewCell: UICollectionViewCell {
    
    // MARK: - Declaration
    struct Payload {
        let review: ReviewEntity
    }
    
    // MARK: - Interface
    var payload: Payload? {
        didSet { updateUI() }
    }
    var delegate: ProductDetailReviewCellDelegate?
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
        configureAction()
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
    
    private func configureAction() {
        viewHolder.goodButton.addTapGesture(target: self, action: #selector(goodButtonAction(_:)))
        viewHolder.badButton.addTapGesture(target: self, action: #selector(badButtonAction(_:)))
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
        
        viewHolder.goodButton.payload = .init(feedbackKind: .good, isSelected: false, count: review.likeCount)
        viewHolder.badButton.payload = .init(feedbackKind: .bad, isSelected: false, count: review.hateCount)
    }
    
    @objc private func goodButtonAction(_ sender: UITapGestureRecognizer) {
        guard let payload else { return }
        delegate?.goodButtonDidTap(review: payload.review)
    }
    
    @objc private func badButtonAction(_ sender: UITapGestureRecognizer) {
        guard let payload else { return }
        delegate?.badButtonDidTap(review: payload.review)
    }
}
