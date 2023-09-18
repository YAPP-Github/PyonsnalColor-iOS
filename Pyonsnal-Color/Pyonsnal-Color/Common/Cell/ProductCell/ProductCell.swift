//
//  ProductCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/14.
//

import UIKit
import Combine
import SnapKit

protocol ProductCellDelegate: AnyObject {
    func didTapFavoriteButton(product: any ProductConvertable, action: FavoriteButtonAction)
}

final class ProductCell: UICollectionViewCell {
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private var cancellable = Set<AnyCancellable>()
    private var product: (any ProductConvertable)?
    
    weak var delegate: ProductCellDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindActions() {
        viewHolder.favoriteButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self, let product else { return }
                let isSelected = !viewHolder.favoriteButton.isSelected
                self.setFavoriteButtonSelected(isSelected: isSelected)
                
                let action: FavoriteButtonAction = getFavoriteButtonSelected() ? .add : .delete
                self.delegate?.didTapFavoriteButton(product: product, action: action)
            }.store(in: &cancellable)
    }
    
    func updateCell(with product: (any ProductConvertable)?) {
        guard let product else { return }
        self.product = product
        viewHolder.titleLabel.text = product.name
        if let storeTypeImage = product.storeType.storeTagImage {
            viewHolder.convenienceStoreTagImageView.setImage(storeTypeImage)
        }
        viewHolder.itemImageView.setImage(with: product.imageURL)
        viewHolder.originalPriceLabel.text = product.price.addWon()
        viewHolder.newTagView.isHidden = !(product.isNew ?? false)
        if product.isNew ?? false {
            viewHolder.newTagView.snp.updateConstraints { make in
                make.width.equalTo(Size.newImageViewWidth)
            }
            
            viewHolder.titleLabel.snp.updateConstraints { make in
                make.leading.equalTo(viewHolder.newTagView.snp.trailing).offset(.spacing4)
            }
        } else {
            viewHolder.newTagView.snp.updateConstraints { make in
                make.width.equalTo(0)
            }
            viewHolder.titleLabel.snp.updateConstraints { make in
                make.leading.equalTo(viewHolder.newTagView.snp.trailing)
            }
        }
        
        hasEventType(product.eventType)
    }
    
    // MARK: - Private Method
    private func configureUI() {
        let attributedText = viewHolder.discountPriceLabel.text?.strikeThrough(with: .gray500)
        viewHolder.discountPriceLabel.attributedText = attributedText
        viewHolder.convenienceStoreTagImageView.makeRounded(with: Size.convenientTagImageViewWidth / 2)
        makeRounded(with: Size.cornerRadius)
        makeBorder(width: Size.borderWidth, color: UIColor.gray200.cgColor)
        setFavoriteButton(isVisible: true)
    }
    
    private func hasEventType(_ event: EventTag?) {
        if let eventName = event?.name, !eventName.isEmpty {
            viewHolder.eventTagLabel.isHidden = false
            viewHolder.eventTagLabel.text = eventName
        } else {
            viewHolder.eventTagLabel.isHidden = true
        }
    }
    
    func setFavoriteButton(isVisible: Bool) {
        viewHolder.favoriteButton.isHidden = !isVisible
    }
    
    func setFavoriteButtonSelected(isSelected: Bool) {
        viewHolder.favoriteButton.isSelected = isSelected
    }
    
    func getFavoriteButtonSelected() -> Bool {
        return viewHolder.favoriteButton.isSelected
    }
    
    func showEventCloseLayerView(isClosed: Bool) {
        viewHolder.eventCloseLayerView.isHidden = !isClosed
        if isClosed {
            self.updateFavoriteButtonConstraints()
        }
    }
    
    private func updateFavoriteButtonConstraints() {
        viewHolder.favoriteButton.removeFromSuperview()
        viewHolder.eventCloseLayerView.addSubview(viewHolder.favoriteButton)
        viewHolder.updateFavoriteButtonConstraints()
    }

}
