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
}

protocol ProductHomePresentable: Presentable {
    var listener: ProductHomePresentableListener? { get set }
    
    func updateProducts(with products: [ConvenienceStore: [BrandProductEntity]])
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
    private var brandProducts: [ConvenienceStore: [BrandProductEntity]] = [:] {
        didSet {
            presenter.updateProducts(with: brandProducts)
            presenter.didFinishPaging()
        }
    }

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
    
    func didChangeStore(to store: ConvenienceStore) {
        requestInitialProducts(store: store)
    }
    
    func didTabProductCell(at index: Int) {
        // TODO: 상품 상세 조회
    }
}
