//
//  EventHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import Combine
import ModernRIBs

protocol EventHomeRouting: ViewableRouting {
    func attachProductSearch()
    func detachProductSearch()
    func attachEventDetail(with imageURL: String, store: ConvenienceStore)
    func detachEventDetail()
    func attachProductDetail(with brandProduct: ProductConvertable)
    func detachProductDetail()
}

protocol EventHomePresentable: Presentable {
    var listener: EventHomePresentableListener? { get set }
    
    func updateProducts(with products: [EventProductEntity], at store: ConvenienceStore)
    func update(with products: [EventProductEntity], banners: [EventBannerEntity], at store: ConvenienceStore)
    func didFinishPaging()
}

protocol EventHomeListener: AnyObject {
}

final class EventHomeInteractor:
    PresentableInteractor<EventHomePresentable>,
    EventHomeInteractable,
    EventHomePresentableListener {

    weak var router: EventHomeRouting?
    weak var listener: EventHomeListener?
    
    private var dependency: EventHomeDependency?
    private var cancellable = Set<AnyCancellable>()
    private let initialPage: Int = 0
    private let initialCount: Int = 20
    private let productPerPage: Int = 20
    private var storeLastPages: [ConvenienceStore: Int] = [:]

    init(
        presenter: EventHomePresentable,
        dependency: EventHomeDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func requestProducts(pageNumber: Int, store: ConvenienceStore) {
        storeLastPages[store] = pageNumber
        dependency?.productAPIService.requestEventProduct(
            pageNumber: pageNumber,
            pageSize: productPerPage,
            storeType: store
        ).sink { [weak self] response in
            if let productPage = response.value {
                self?.presenter.updateProducts(with: productPage.content, at: store)
                self?.presenter.didFinishPaging()
            }
        }.store(in: &cancellable)
    }
    
    private func requestProductWithBanners(store: ConvenienceStore) {
        storeLastPages[store] = initialPage
        let eventPublisher = dependency?.productAPIService.requestEventBanner(storeType: store)
        let productPublisher = dependency?.productAPIService.requestEventProduct(
            pageNumber: initialPage,
            pageSize: initialCount,
            storeType: store
        )
        guard let eventPublisher,
              let productPublisher else { return }
        
        eventPublisher
            .combineLatest(productPublisher)
            .sink { [weak self] event, product in
            if let event = event.value,
               let product = product.value?.content {
                self?.presenter.update(with: product, banners: event, at: store)
            }
        }.store(in: &cancellable)
    }
    
    func didTapSearchButton() {
        router?.attachProductSearch()
    }
    
    func popProductSearch() {
        router?.detachProductSearch()
    }
    
    func didTapEventBannerCell(with imageURL: String, store: ConvenienceStore) {
        router?.attachEventDetail(with: imageURL, store: store)
    }
    
    func didTapBackButton() {
        router?.detachEventDetail()
    }
    
    func didTapProductCell() {
        // TO DO : 아이템 카드 클릭시
    }
    
    func didLoadEventHome(with store: ConvenienceStore) {
        requestProductWithBanners(store: store)
    }
    
    func didSelect(with brandProduct: ProductConvertable) {
        router?.attachProductDetail(with: brandProduct)
    }
    
    func popProductDetail() {
        router?.detachProductDetail()
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        requestProductWithBanners(store: store)
    }
    
    func didScrollToNextPage(store: ConvenienceStore) {
        if let lastPage = storeLastPages[store] {
            requestProducts(pageNumber: lastPage + 1, store: store)
        }
    }
}
