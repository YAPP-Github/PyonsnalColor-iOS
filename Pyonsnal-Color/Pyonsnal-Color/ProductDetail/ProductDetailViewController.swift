//
//  ProductDetailViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import UIKit
import Combine
import ModernRIBs

protocol ProductDetailPresentableListener: AnyObject {
    func popViewController()
    func addFavorite()
    func deleteFavorite()
}

final class ProductDetailViewController:
    UIViewController,
    ProductDetailPresentable,
    ProductDetailViewControllable
{
    // MARK: - Declaration
    enum Text {
        static let updateLabelTextPrefix: String = "업데이트"
    }
    
    // MARK: - Interface
    weak var listener: ProductDetailPresentableListener?
    var product: (any ProductConvertable)? {
        didSet { updateUI() }
    }
    
    // MARK: - Private Method
    private let viewHolder: ViewHolder = .init()
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        
        configureAction()
        bindActions()
    }
    
    // MARK: - Private Method
    private func updateUI() {
        view.backgroundColor = .white
        guard let product else { return }
        
        viewHolder.backNavigationView.payload = .init(
            mode: .image,
            title: nil,
            iconImageKind: product.storeType.storeIcon
        )
        viewHolder.productImageView.setImage(with: product.imageURL)
        viewHolder.productTagListView.payload = .init(
            isNew: product.isNew ?? false,
            eventTags: product.eventType
        )
        viewHolder.updateDateLabel.text = "\(Text.updateLabelTextPrefix) \(product.updatedTime)"
        viewHolder.productNameLabel.text = product.name
        viewHolder.productPriceLabel.text = product.price
        viewHolder.backNavigationView.setFavoriteButtonSelected(isSelected: product.isFavorite)
        let description = product.description?
            .components(separatedBy: .whitespacesAndNewlines)
            .joined(separator: " ")
        viewHolder.productDescriptionLabel.text = description
    }
    
    private func configureAction() {
        viewHolder.backNavigationView.delegate = self
    }
    
    private func bindActions() {
        viewHolder.backNavigationView.favoriteButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self else { return }
                let isSelected = !viewHolder.backNavigationView.favoriteButton.isSelected
                viewHolder.backNavigationView.setFavoriteButtonSelected(isSelected: isSelected)
                
                let action: FavoriteButtonAction = viewHolder.backNavigationView.getFavoriteButtonSelected() ? .add : .delete
                if action == .add {
                    listener?.addFavorite()
                } else if action == .delete {
                    listener?.deleteFavorite()
                }
            }.store(in: &cancellable)
    }
}

extension ProductDetailViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.popViewController()
    }
}
