//
//  EventHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol EventHomeInteractable: Interactable,
                                EventDetailListener {
    var router: EventHomeRouting? { get set }
    var listener: EventHomeListener? { get set }
}

protocol EventHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class EventHomeRouter: ViewableRouter<EventHomeInteractable, EventHomeViewControllable>,
                             EventHomeRouting {

    private let eventDetailBuilder: EventDetailBuilder
    private var eventDetailRouting: ViewableRouting?

    init(interactor: EventHomeInteractable,
         viewController: EventHomeViewControllable,
         eventDetailBuilder: EventDetailBuilder) {
        self.eventDetailBuilder = eventDetailBuilder
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
    }
    
    func attachEventDetail() {
        guard eventDetailRouting == nil else { return }
        let eventDetailRouter = eventDetailBuilder.build(withListener: interactor)
        viewController.pushViewController(eventDetailRouter.viewControllable,
                                          animated: true)
        attachChild(eventDetailRouter)
        self.eventDetailRouting = eventDetailRouter
    }
    
    func detachEventDetail() {
        guard let router = eventDetailRouting else { return }
        viewController.popViewController(animated: true)
        self.eventDetailRouting = nil
        detachChild(router)
    }
    
}
