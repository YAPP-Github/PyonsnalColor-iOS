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
    private func configureUI() {
        let giftItem: GiftItemEntity = .init(
            name: "화이트초콜릿모카 아이스",
            price: "5,900원",
            imageURL: .init(string: "https://www.google.com")!
        )
        
        self.product = .init(
            imageURL: .init(string: "https://www.google.com")!,
            updated: "업데이트 23.06.24",
            name: "오리온) 눈을 감자",
            price: "3800원",
            description: "상세 정보 없음",
            giftItem: giftItem
        )
    }
    
    // ViewModel 바인딩으로 대체 예정
    var product: ProductEntity? {
        didSet { updateUI() }
    }
    
    private func updateUI() {
        guard let product else { return }
        
        viewHolder.updateDateLabel.text = product.updated
        viewHolder.productNameLabel.text = product.name
        viewHolder.productPriceLabel.text = product.price
        viewHolder.productDescriptionLabel.text = product.description
        viewHolder.giftInformationView.giftItem = product.giftItem
    }
}
