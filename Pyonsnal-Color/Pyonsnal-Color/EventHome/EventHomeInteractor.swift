//
//  EventHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import Combine
import ModernRIBs

protocol EventHomeRouting: ViewableRouting {
    func attachEventDetail(with imageUrl: String)
    func detachEventDetail()
}

protocol EventHomePresentable: Presentable {
    var listener: EventHomePresentableListener? { get set }
    
    func updateProducts(with products: [EventProductEntity])
    func updateBanners(with banners: [EventBannerEntity])
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
    private let initialPage: Int = 1
    private let initialCount: Int = 20
    private let productPerPage: Int = 10
    private var currentPage: Int = 1
    private var nextPage: Int { currentPage + 1 }

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
    
    private func requestProducts(pageNumber: Int, pageSize: Int, store: ConvenienceStore = .all) {
        dependency?.productAPIService.requestEventProduct(
            pageNumber: pageNumber,
            pageSize: pageSize,
            storeType: store
        ).sink { [weak self] response in
            if let productPage = response.value {
                print(self?.presenter)
                print(productPage.content)
                self?.presenter.updateProducts(with: productPage.content)
            }
        }.store(in: &cancellable)
    }
    
    private func requestEventBanners(store: ConvenienceStore) {
        if store != .all {
            dependency?.productAPIService.requestEventBanner(storeType: store)
                .sink { [weak self] response in
                    if let eventBanners = response.value {
                        self?.presenter.updateBanners(with: eventBanners)
                    }
                }.store(in: &cancellable)
        }
    }
    
    func didTapEventBannerCell(with imageUrl: String) {
        router?.attachEventDetail(with: imageUrl)
    }
    
    func didTapBackButton() {
        router?.detachEventDetail()
    }
    
    func didTapProductCell() {
        // TO DO : 아이템 카드 클릭시
    }
    
    func didLoadEventHome() {
        requestProducts(pageNumber: currentPage, pageSize: initialCount)
    }
    
    func didChangeStore(to store: ConvenienceStore) {
        requestProducts(pageNumber: initialPage, pageSize: initialCount, store: store)
        requestEventBanners(store: store)
    }
}
