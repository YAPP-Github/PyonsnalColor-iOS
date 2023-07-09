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
    
    private func requestProducts(pageNumber: Int, pageSize: Int) {
        dependency?.productAPIService.requestEventProduct(
            pageNumber: pageNumber,
            pageSize: pageSize
        ).sink { [weak self] response in
            if let productPage = response.value {
                print(self?.presenter)
                print(productPage.content)
                self?.presenter.updateProducts(with: productPage.content)
            }
        }.store(in: &cancellable)
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
    
    func viewWillAppear() {
        requestProducts(pageNumber: currentPage, pageSize: initialCount)
    }
    
}
