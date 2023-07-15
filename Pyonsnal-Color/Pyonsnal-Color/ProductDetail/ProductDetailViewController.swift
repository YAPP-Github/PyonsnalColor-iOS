//
//  ProductDetailViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs
import UIKit

protocol ProductDetailPresentableListener: AnyObject {
    func popViewController()
}

final class ProductDetailViewController:
    UIViewController,
    ProductDetailPresentable,
    ProductDetailViewControllable
{
    // MARK: - Interface
    weak var listener: ProductDetailPresentableListener?
    var product: ProductConvertable? {
        didSet { updateUI() }
    }
    
    // MARK: - Private Method
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        
        configureAction()
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
            isNew: product.isNew,
            eventTags: product.eventType
        )
        viewHolder.updateDateLabel.text = product.updatedTime
        viewHolder.productNameLabel.text = product.name
        viewHolder.productPriceLabel.text = product.price
        let description = product.description?
            .components(separatedBy: .whitespacesAndNewlines)
            .joined(separator: " ")
        viewHolder.productDescriptionLabel.text = description
    }
    
    private func configureAction() {
        viewHolder.backNavigationView.delegate = self
    }
}

extension ProductDetailViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.popViewController()
    }
}
