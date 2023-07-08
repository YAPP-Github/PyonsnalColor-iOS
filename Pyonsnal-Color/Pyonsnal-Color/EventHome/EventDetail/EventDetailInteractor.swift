//
//  EventDetailInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/01.
//

import ModernRIBs

protocol EventDetailRouting: ViewableRouting {
    
}

protocol EventDetailPresentable: Presentable {
    var listener: EventDetailPresentableListener? { get set }
   
    func update(with imageUrl: String)
}

protocol EventDetailListener: AnyObject {
    func didTapBackButton()
}

final class EventDetailInteractor: PresentableInteractor<EventDetailPresentable>,
                                   EventDetailInteractable,
                                   EventDetailPresentableListener {
    
    private var imageUrl: String
    weak var router: EventDetailRouting?
    weak var listener: EventDetailListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: EventDetailPresentable, imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.update(with: imageUrl)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
