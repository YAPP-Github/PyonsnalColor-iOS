//
//  ProductDetailInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs
import Combine

protocol ProductDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProductDetailPresentable: Presentable {
    var listener: ProductDetailPresentableListener? { get set }
    func setFavoriteState(isSelected: Bool)
}

protocol ProductDetailListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func popProductDetail()
}

final class ProductDetailInteractor: PresentableInteractor<ProductDetailPresentable>,
                                     ProductDetailInteractable,
                                     ProductDetailPresentableListener {

    weak var router: ProductDetailRouting?
    weak var listener: ProductDetailListener?
    private let favoriteAPIService: FavoriteAPIService
    private let product: any ProductConvertable
    private var cancellable = Set<AnyCancellable>()
    
    init(
        presenter: ProductDetailPresentable,
        favoriteAPIService: FavoriteAPIService,
        product: any ProductConvertable
    ) {
        self.favoriteAPIService = favoriteAPIService
        self.product = product
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func popViewController() {
        listener?.popProductDetail()
    }
    
    func addFavorite() {
        favoriteAPIService.addFavorite(
            productId: product.productId,
            productType: product.productType
            ).sink { [weak self] response in
                if response.error != nil {
                    self?.presenter.setFavoriteState(isSelected: true)
                } else {
                   // TODO: error handling
                }
            }.store(in: &cancellable)
        }
        
        func deleteFavorite() {
            favoriteAPIService.deleteFavorite(
                productId: product.productId,
                productType: product.productType
            ).sink { [weak self] response in
                if response.error != nil {
                    self?.presenter.setFavoriteState(isSelected: false)
                } else {
                    // TODO: error handling
                }
            }.store(in: &cancellable)
        }

}
