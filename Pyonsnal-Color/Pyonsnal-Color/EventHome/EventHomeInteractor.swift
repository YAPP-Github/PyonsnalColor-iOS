//
//  EventHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol EventHomeRouting: ViewableRouting {
    func attachEventDetail()
    func detachEventDetail()
}

protocol EventHomePresentable: Presentable {
    var listener: EventHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol EventHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class EventHomeInteractor: PresentableInteractor<EventHomePresentable>, EventHomeInteractable, EventHomePresentableListener {

    weak var router: EventHomeRouting?
    weak var listener: EventHomeListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: EventHomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapEventBannerCell() {
        router?.attachEventDetail()
    }
    
    func didTapBackButton() {
        router?.detachEventDetail()
    }
    
    func didTapProductCell() {
        // TO DO : 아이템 카드 클릭시
    }
    
}
