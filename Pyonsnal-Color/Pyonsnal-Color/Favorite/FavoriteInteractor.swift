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
    func updateProducts(products: [any ProductConvertable]?, tab: FavoriteTab)
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
    
    private var isPbPagingEnabled: Bool = true
    private var isEventPagingEnabled: Bool = true
    var isPagingEnabled: Bool {
        return isPbPagingEnabled && isEventPagingEnabled
    }
    private var isPbPagingNumberLoadMore: Bool = true
    private var isEventPagingNumberLoadMore: Bool = true
    
    private var productDictionary: [FavoriteTab: [any ProductConvertable]] = [:]
    
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
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    // pb, event 찜하기 상품 조회
    func requestFavoriteProducts() {
        self.requestPbProducts()
        self.requestEventProducts()
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
        let group = DispatchGroup()
        for product in self.deletedProducts {
            group.enter()
            self.favoriteAPIService.deleteFavorite(
                productId: product.productId,
                productType: product.productType
            ).sink { _ in
                group.leave()
            }.store(in: &self.cancellable)
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.deletedProducts = []
            self?.requestFavoriteProducts()
        }
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
            guard let self else { return }
            if let product = response.value {
                self.isPbPagingNumberLoadMore = !product.isLast
                self.productDictionary[.product] = product.content
                self.presenter.updateProducts(
                    products: self.productDictionary[.product],
                    tab: .product
                )
            } else {
                // TODO: Error Handling
            }
            self.isPbPagingEnabled = true
        }.store(in: &cancellable)
    }
    
    private func loadMorePbProducts() { // for pagination
        self.isPbPagingEnabled = false
        if !self.isPbPagingNumberLoadMore {
            self.isPbPagingEnabled = true
            return
        }
        self.pbPageNumber += 1
        
        favoriteAPIService.favorites(
            pageNumber: pbPageNumber,
            pageSize: pageSize,
            productType: .pb,
            model: BrandProductEntity.self
        ).sink { [weak self] response in
            guard let self else { return }
            if let product = response.value {
                self.isPbPagingNumberLoadMore = !product.isLast
                self.productDictionary[.product]? += product.content
                self.presenter.updateProducts(
                    products: self.productDictionary[.product],
                    tab: .product
                )
            } else {
                // TODO: Error Handling
            }
            self.isPbPagingEnabled = true
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
            guard let self else { return }
            if let product = response.value {
                self.isEventPagingNumberLoadMore = !product.isLast
                self.productDictionary[.event] = product.content
                self.presenter.updateProducts(
                    products: self.productDictionary[.event],
                    tab: .event
                )
            } else {
                // TODO: Error Handling
            }
            self.isEventPagingEnabled = true
        }.store(in: &cancellable)
    }
    
    private func loadMoreEventProducts() { // for pagination
        self.isEventPagingEnabled = false
        if !self.isEventPagingNumberLoadMore { 
            self.isEventPagingEnabled = true
            return
        }
        self.eventPageNumber += 1
        favoriteAPIService.favorites(
            pageNumber: eventPageNumber,
            pageSize: pageSize,
            productType: .event,
            model: EventProductEntity.self
        ).sink { [weak self] response in
            guard let self else { return }
            if let product = response.value {
                self.isEventPagingNumberLoadMore = !product.isLast
                self.productDictionary[.event]? += product.content
                self.presenter.updateProducts(
                    products: self.productDictionary[.event],
                    tab: .event
                )
            } else {
                // TODO: Error Handling
            }
            self.isEventPagingEnabled = true
        }.store(in: &cancellable)
    }
    
    func loadMoreItems(type: ProductType) {
        if !isPagingEnabled { return }
        switch type {
        case .pb:
            self.loadMorePbProducts()
        case .event:
            self.loadMoreEventProducts()
        }
    }
}
