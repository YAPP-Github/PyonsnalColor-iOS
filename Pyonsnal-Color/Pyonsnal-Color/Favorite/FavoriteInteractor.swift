//
//  FavoriteInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs
import Combine
import Foundation

protocol FavoriteRouting: ViewableRouting {
    func attachProductSearch()
    func detachProductSearch()
    func attachProductDetail(with product: any ProductConvertable)
    func detachProductDetail()
}

protocol FavoritePresentable: Presentable {
    var listener: FavoritePresentableListener? { get set }
    func updateProducts(products: [[any ProductConvertable]])
}

protocol FavoriteListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FavoriteInteractor: PresentableInteractor<FavoritePresentable>,
                                FavoriteInteractable,
                                FavoritePresentableListener {
    // MARK: - Interfaces
    weak var router: FavoriteRouting?
    weak var listener: FavoriteListener?
    
    // MARK: - Private Proverty
    private let favoriteAPIService: FavoriteAPIService
    private var cancellable = Set<AnyCancellable>()
    
    private var pbPageNumber: Int = 0
    private var eventPageNumber: Int = 0
    private let pageSize: Int = 20
    private var deletedProducts = [any ProductConvertable]()
    
    private var isPbPagingEnabled: Bool = false
    private var isEventPagingEnabled: Bool = false
    
    let pbProduct = PassthroughSubject<[any ProductConvertable], Never>()
    let eventProduct = PassthroughSubject<[any ProductConvertable], Never>()
    
    // MARK: - Initializer
    init(
        presenter: FavoritePresentable,
        favoriteAPIService: FavoriteAPIService
    ) {
        self.favoriteAPIService = favoriteAPIService
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bindActions()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    // pb, event 찜하기 상품 조회
    func requestFavoriteProducts() {
        Task {
            requestPbProducts()
            requestEventProducts()
        }
    }
    
    func appendProduct(product: any ProductConvertable) {
        if let index = deletedProducts.firstIndex(where: { $0.productId == product.productId }) {
            deletedProducts.remove(at: index)
        }
    }
    
    func deleteProduct(product: any ProductConvertable) {
        deletedProducts.append(product)
    }
    
    func deleteAllProducts() {
        for product in deletedProducts {
            favoriteAPIService.deleteFavorite(
                productId: product.productId,
                productType: .pb // product.productType
            ).sink { response in
                    if response.error != nil {
                        Log.d(message: "success")
                    }
                }.store(in: &cancellable)
        }
        deletedProducts = []
    }
    
    func didTapSearchButton() {
        router?.attachProductSearch()
    }
    
    func popProductSearch() {
        router?.detachProductSearch()
    }
    
    func didSelect(with product: any ProductConvertable) {
        router?.attachProductDetail(with: product)
    }
    
    func popProductDetail() {
        router?.detachProductDetail()
    }
    
    private func requestPbProducts() {
        favoriteAPIService.favorites(
            pageNumber: pbPageNumber,
            pageSize: pageSize,
            productType: .pb
        ).sink { [weak self] response in
            if let product = response.value {
                self?.isPbPagingEnabled = !product.isLast
                self?.pbProduct.send(product.content)
            } else {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    private func requestEventProducts() {
        favoriteAPIService.favorites(
            pageNumber: eventPageNumber,
            pageSize: pageSize,
            productType: .event
        ).sink { [weak self] response in
            if let product = response.value {
                self?.isEventPagingEnabled = !product.isLast
                self?.eventProduct.send(product.content)
            } else {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    private func bindActions() {
        pbProduct
            .combineLatest(eventProduct)
            .sink { [weak self] pbProduct, eventProduct in
                let totalProducts = [pbProduct, eventProduct]
                self?.presenter.updateProducts(products: [pbProduct, eventProduct])
            }.store(in: &cancellable)
    }
    
}
