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
    func update(with imageURL: String, links: [String])
}

protocol EventDetailListener: AnyObject {
    func didTapBackButton()
}

final class EventDetailInteractor: PresentableInteractor<EventDetailPresentable>,
                                   EventDetailInteractable,
                                   EventDetailPresentableListener {
    
    private let component: EventDetailComponent
    
    weak var router: EventDetailRouting?
    weak var listener: EventDetailListener?

    init(
        presenter: EventDetailPresentable,
        component: EventDetailComponent
    ) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if let store = component.store {
            presenter.update(with: component.imageURL, store: store)
        } else if let links = component.links {
            presenter.update(with: component.imageURL, links: links)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
