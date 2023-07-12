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
    func update(with imageUrl: String, store: ConvenienceStore)
}

protocol EventDetailListener: AnyObject {
    func didTapBackButton()
}

final class EventDetailInteractor: PresentableInteractor<EventDetailPresentable>,
                                   EventDetailInteractable,
                                   EventDetailPresentableListener {
    
    private var imageUrl: String
    private var store: ConvenienceStore
    weak var router: EventDetailRouting?
    weak var listener: EventDetailListener?

    init(presenter: EventDetailPresentable, imageUrl: String, store: ConvenienceStore) {
        self.imageUrl = imageUrl
        self.store = store
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.update(with: imageUrl, store: store)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
