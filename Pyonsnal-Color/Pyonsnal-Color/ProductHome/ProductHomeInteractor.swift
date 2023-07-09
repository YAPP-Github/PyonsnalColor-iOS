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
    
    func updateProducts(with products: [BrandProductEntity])
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
    private let initialCount: Int = 20
    private let initialPage: Int = 1
    private let productPerPage: Int = 10
    private var currentPage: Int = 1
    private var nextPage: Int { currentPage + 1 }

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
        
        requestProducts(pageNumber: currentPage, pageSize: initialCount)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func requestProducts(pageNumber: Int, pageSize: Int, store: ConvenienceStore = .all) {
        dependency?.productAPIService.requestBrandProduct(
            pageNumber: pageNumber,
            pageSize: pageSize,
            storeType: store
        ).sink { [weak self] response in
            if let productPage = response.value {
                print(self?.presenter)
                print(productPage.content)
                self?.presenter.updateProducts(with: productPage.content)
            } else if response.error != nil {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    func didTapNotificationButton() {
        router?.attachNotificationList()
    }
    
    func notificationListDidTapBackButton() {
        router?.detachNotificationList()
    }
    
    func didScrollToNextPage() {
        requestProducts(pageNumber: nextPage, pageSize: productPerPage)
        currentPage = nextPage
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        requestProducts(pageNumber: initialPage, pageSize: initialCount, store: store)
    }
}
