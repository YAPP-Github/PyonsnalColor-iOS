//
//  EventHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import Combine
import ModernRIBs

protocol EventHomeRouting: ViewableRouting {
    func attachEventDetail(with imageURL: String, store: ConvenienceStore)
    func detachEventDetail()
}

protocol EventHomePresentable: Presentable {
    var listener: EventHomePresentableListener? { get set }
    
    func updateProducts(with products: [EventProductEntity], at store: ConvenienceStore)
    func updateBanners(with banners: [EventBannerEntity], at store: ConvenienceStore)
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
    private var eventProducts: [ConvenienceStore: [EventProductEntity]] = [:]

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
    
    private func requestInitialProducts(store: ConvenienceStore = .all) {
        storeLastPages[store] = initialPage
        
        dependency?.productAPIService.requestEventProduct(
            pageNumber: initialPage,
            pageSize: initialCount,
            storeType: store
        ).sink { [weak self] response in
            if let productPage = response.value {
                self?.eventProducts[store] = productPage.content
                if let products = self?.eventProducts[store] {
                    self?.presenter.updateProducts(with: products, at: store)
                }
            } else if response.error != nil {
                // TODO: Error Handling
            }
        }.store(in: &cancellable)
    }
    
    private func requestProducts(pageNumber: Int, store: ConvenienceStore) {
        storeLastPages[store] = pageNumber
        dependency?.productAPIService.requestEventProduct(
            pageNumber: pageNumber,
            pageSize: productPerPage,
            storeType: store
        ).sink { [weak self] response in
            if let productPage = response.value {
                self?.eventProducts[store]? += productPage.content
                if let products = self?.eventProducts[store] {
                    self?.presenter.updateProducts(with: products, at: store)
                    self?.presenter.didFinishPaging()
                }
            }
        }.store(in: &cancellable)
    }
    
    private func requestEventBanners(store: ConvenienceStore) {
        if store != .all {
            dependency?.productAPIService.requestEventBanner(storeType: store)
                .sink { [weak self] response in
                    if let eventBanners = response.value {
                        self?.presenter.updateBanners(with: eventBanners, at: store)
                    }
                }.store(in: &cancellable)
        }
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
    
    func didLoadEventHome() {
        requestInitialProducts()
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        requestInitialProducts(store: store)
        
        if store != .all {
            requestEventBanners(store: store)
        }
    }
    
    func didScrollToNextPage(store: ConvenienceStore) {
        if let lastPage = storeLastPages[store] {
            requestProducts(pageNumber: lastPage + 1, store: store)
        }
    }
}
