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
    
    private var imageURL: String
    private var store: ConvenienceStore?
    private var links: [String]?
    
    weak var router: EventDetailRouting?
    weak var listener: EventDetailListener?

    init(
        presenter: EventDetailPresentable,
        imageURL: String,
        store: ConvenienceStore? = nil,
        links: [String]? = nil
    ) {
        self.imageURL = imageURL
        self.store = store
        self.links = links
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if let store {
            presenter.update(with: imageURL, store: store)
        } else if let links {
            presenter.update(with: imageURL, links: links)
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
