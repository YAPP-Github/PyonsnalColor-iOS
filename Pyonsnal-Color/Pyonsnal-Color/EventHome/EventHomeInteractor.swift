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
    func attachProductFilter(of filter: FilterEntity)
    func detachProductFilter()
}

protocol EventHomePresentable: Presentable {
    var listener: EventHomePresentableListener? { get set }
    
    func updateProducts(with products: [EventProductEntity], at store: ConvenienceStore)
    func update(with products: [EventProductEntity], banners: [EventBannerEntity], at store: ConvenienceStore)
    func updateFilter(with filters: FilterDataEntity)
    func didFinishPaging()
    func updateFilterItems(with items: [FilterItemEntity])
    func updateSortFilter(type: FilterItemEntity)
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
    
    private func requestProducts(pageNumber: Int, store: ConvenienceStore, filterList: [String]) {
        storeLastPages[store] = pageNumber
        dependency?.productAPIService.requestEventProduct(
            pageNumber: pageNumber,
            pageSize: productPerPage,
            storeType: store,
            filterList: filterList
        ).sink { [weak self] response in
            if let productPage = response.value {
                self?.presenter.updateProducts(with: productPage.content, at: store)
                self?.presenter.didFinishPaging()
            }
        }.store(in: &cancellable)
    }
    
    private func requestProductWithBanners(store: ConvenienceStore, filterList: [String]) {
        storeLastPages[store] = initialPage
        let eventPublisher = dependency?.productAPIService.requestEventBanner(storeType: store)
        let productPublisher = dependency?.productAPIService.requestEventProduct(
            pageNumber: initialPage,
            pageSize: initialCount,
            storeType: store,
            filterList: filterList
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
    
    private func requestFilter() {
        dependency?.productAPIService.requestFilter()
            .sink { [weak self] response in
                if let filter = response.value {
                    self?.presenter.updateFilter(with: filter)
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
    
    func didLoadEventHome(with store: ConvenienceStore) {
        requestProductWithBanners(store: store, filterList: [])
        requestFilter()
    }
    
    func didSelect(with brandProduct: ProductConvertable) {
        router?.attachProductDetail(with: brandProduct)
    }
    
    func popProductDetail() {
        router?.detachProductDetail()
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        requestProductWithBanners(store: store, filterList: [])
    }
    
    func didScrollToNextPage(store: ConvenienceStore) {
        if let lastPage = storeLastPages[store] {
            requestProducts(pageNumber: lastPage + 1, store: store, filterList: [])
        }
    }
    
    func didSelectFilter(of filter: FilterEntity?) {
        guard let filter else { return }
        
        router?.attachProductFilter(of: filter)
    }
    
    func productFilterDidTapCloseButton() {
        router?.detachProductFilter()
    }
    
    func applyFilterItems(_ items: [FilterItemEntity]) {
        // TODO: 적용된 필터로 상품 목록 조회하기
        router?.detachProductFilter()
        presenter.updateFilterItems(with: items)
    }
    
    func applySortFilter(type: FilterItemEntity) {
        // TODO: 적용된 필터로 상품 목록 조회하기
        router?.detachProductFilter()
        presenter.updateSortFilter(type: type)
    }
    
    func didTapRefreshFilterCell(with store: ConvenienceStore) {
        requestProductWithBanners(store: store, filterList: [])
    }
    
    func requestwithUpdatedKeywordFilter(with store: ConvenienceStore, filterList: [String]) {
        requestProductWithBanners(store: store, filterList: filterList)
    }
}
