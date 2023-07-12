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
    func update(with imageURL: String, store: ConvenienceStore)
}

protocol EventDetailListener: AnyObject {
    func didTapBackButton()
}

final class EventDetailInteractor: PresentableInteractor<EventDetailPresentable>,
                                   EventDetailInteractable,
                                   EventDetailPresentableListener {
    
    private var imageURL: String
    private var store: ConvenienceStore
    weak var router: EventDetailRouting?
    weak var listener: EventDetailListener?

    init(presenter: EventDetailPresentable, imageURL: String, store: ConvenienceStore) {
        self.imageURL = imageURL
        self.store = store
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.update(with: imageURL, store: store)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
