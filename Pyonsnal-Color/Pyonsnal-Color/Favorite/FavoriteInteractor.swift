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
    
    var isPbPagingEnabled: Bool = true
    var isEventPagingEnabled: Bool = true
    var isPagingEnabled: Bool {
        return isPbPagingEnabled && isEventPagingEnabled
    }
    private var isPbPagingNumberLoadMore: Bool = true
    private var isEventPagingNumberLoadMore: Bool = true
    
    let pbProduct = CurrentValueSubject<[any ProductConvertable], Never>([])
    let eventProduct = CurrentValueSubject<[any ProductConvertable], Never>([])
    
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
            self.requestPbProducts()
            self.requestEventProducts()
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
        self.isPbPagingEnabled = false
        self.pbPageNumber = 0
        favoriteAPIService.favorites(
            pageNumber: pbPageNumber,
            pageSize: pageSize,
            productType: .pb,
            model: BrandProductEntity.self
        ).sink { [weak self] response in
            if let product = response.value {
                self?.isPbPagingNumberLoadMore = !product.isLast
                self?.pbProduct.value = product.content
                self?.isPbPagingEnabled = true
            } else {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    private func loadMorePbProducts() { // for pagination
        self.isPbPagingEnabled = false
        if !self.isPbPagingNumberLoadMore { return }
        self.pbPageNumber += 1
        
        favoriteAPIService.favorites(
            pageNumber: pbPageNumber,
            pageSize: pageSize,
            productType: .pb,
            model: BrandProductEntity.self
        ).sink { [weak self] response in
            
            if let product = response.value {
                self?.isPbPagingNumberLoadMore = !product.isLast
                self?.pbProduct.value += product.content
                self?.isPbPagingEnabled = true
            } else {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    private func requestEventProducts() {
        self.isEventPagingEnabled = false
        self.eventPageNumber = 0
        favoriteAPIService.favorites(
            pageNumber: eventPageNumber,
            pageSize: pageSize,
            productType: .event,
            model: EventProductEntity.self
        ).sink { [weak self] response in
            if let product = response.value {
                self?.isEventPagingNumberLoadMore = !product.isLast
                self?.eventProduct.value = product.content
                self?.isEventPagingEnabled = true
            } else {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    private func loadMoreEventProducts() { // for pagination
        self.isEventPagingEnabled = false
        if !self.isEventPagingNumberLoadMore { return }
        self.eventPageNumber += 1
        
        favoriteAPIService.favorites(
            pageNumber: eventPageNumber,
            pageSize: pageSize,
            productType: .event,
            model: EventProductEntity.self
        ).sink { [weak self] response in
            if let product = response.value {
                self?.isEventPagingNumberLoadMore = !product.isLast
                self?.eventProduct.value += product.content
                self?.isEventPagingEnabled = true
            } else {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    func loadMoreItems(type: ProductType) {
        switch type {
        case .pb:
            self.loadMorePbProducts()
        case .event:
            self.loadMoreEventProducts()
        }
    }
    
    private func bindActions() {
        pbProduct
            .combineLatest(eventProduct)
            .sink { [weak self] pbProduct, eventProduct in
                self?.presenter.updateProducts(products: [pbProduct, eventProduct])
            }.store(in: &cancellable)
    }
    
}
