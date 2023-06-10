//
//  EventHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol EventHomeInteractable: Interactable {
    var router: EventHomeRouting? { get set }
    var listener: EventHomeListener? { get set }
}

protocol EventHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class EventHomeRouter: ViewableRouter<EventHomeInteractable, EventHomeViewControllable>, EventHomeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: EventHomeInteractable, viewController: EventHomeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
