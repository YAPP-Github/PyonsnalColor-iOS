//
//  ProductDetailViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs
import UIKit

protocol ProductDetailPresentableListener: AnyObject {
}

final class ProductDetailViewController:
    UIViewController,
    ProductDetailPresentable,
    ProductDetailViewControllable
{
    // MARK: - Interface
    weak var listener: ProductDetailPresentableListener?
    
    // MARK: - Private Method
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        
        configureUI()
    }
    
    // MARK: - Private Method
    private func updateUI() {
        guard let product else { return }
        
        viewHolder.updateDateLabel.text = product.updatedTime
        viewHolder.productNameLabel.text = product.name
        viewHolder.productPriceLabel.text = product.price
        viewHolder.productDescriptionLabel.text = product.description
    }
}
