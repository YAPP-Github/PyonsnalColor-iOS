//
//  ProductHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import Combine
import ModernRIBs

protocol ProductHomeRouting: ViewableRouting {
    func attachNotificationList()
    func detachNotificationList()
    func attachProductDetail(with brandProduct: ProductConvertable)
    func detachProductDetail()
}

protocol ProductHomePresentable: Presentable {
    var listener: ProductHomePresentableListener? { get set }
    
    func updateProducts(with products: [ConvenienceStore: [BrandProductEntity]])
    func updateProducts(with products: [BrandProductEntity], at store: ConvenienceStore)
    func didFinishPaging()
}

protocol ProductHomeListener: AnyObject {
}

final class ProductHomeInteractor:
    PresentableInteractor<ProductHomePresentable>,
    ProductHomeInteractable,
    ProductHomePresentableListener {

    weak var router: ProductHomeRouting?
    weak var listener: ProductHomeListener?
    
    private var dependency: ProductHomeDependency?
    private var cancellable = Set<AnyCancellable>()
    private let initialPage: Int = 0
    private let initialCount: Int = 20
    private let productPerPage: Int = 20
    private var storeLastPages: [ConvenienceStore: Int] = [:]
    private var brandProducts: [ConvenienceStore: [BrandProductEntity]] = [:]

    init(
        presenter: ProductHomePresentable,
        dependency: ProductHomeDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        requestInitialProducts()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func requestInitialProducts(store: ConvenienceStore = .all) {
        storeLastPages[store] = initialPage
        
        dependency?.productAPIService.requestBrandProduct(
            pageNumber: initialPage,
            pageSize: initialCount,
            storeType: store
        ).sink { [weak self] response in
            if let productPage = response.value {
                self?.brandProducts[store] = productPage.content
                if let products = self?.brandProducts[store] {
                    self?.presenter.updateProducts(with: products, at: store)
                }
            } else if response.error != nil {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    private func requestProducts(pageNumber: Int, store: ConvenienceStore) {
        storeLastPages[store] = pageNumber
        dependency?.productAPIService.requestBrandProduct(
            pageNumber: pageNumber,
            pageSize: productPerPage,
            storeType: store
        ).sink { [weak self] response in
            if let productPage = response.value {
                self?.brandProducts[store]? += productPage.content
                if let products = self?.brandProducts[store] {
                    self?.presenter.updateProducts(with: products, at: store)
                    self?.presenter.didFinishPaging()
                }
            }
        }.store(in: &cancellable)
    }
    
    func didTapNotificationButton() {
        router?.attachNotificationList()
    }
    
    func notificationListDidTapBackButton() {
        router?.detachNotificationList()
    }
    
    func didScrollToNextPage(store: ConvenienceStore) {
        if let lastPage = storeLastPages[store] {
            requestProducts(pageNumber: lastPage + 1, store: store)
        }
    }
    
    func didSelect(with brandProduct: ProductConvertable) {
        router?.attachProductDetail(with: brandProduct)
    }
    
    func popProductDetail() {
        router?.detachProductDetail()
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        requestInitialProducts(store: store)
    }
}
