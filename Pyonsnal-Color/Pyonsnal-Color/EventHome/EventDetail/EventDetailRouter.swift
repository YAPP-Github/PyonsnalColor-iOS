//
//  EventDetailRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/01.
//

import ModernRIBs

protocol EventDetailInteractable: Interactable {
    var router: EventDetailRouting? { get set }
    var listener: EventDetailListener? { get set }
}

protocol EventDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class EventDetailRouter: ViewableRouter<EventDetailInteractable, EventDetailViewControllable>, EventDetailRouting {
    
    
    override init(interactor: EventDetailInteractable, viewController: EventDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

}
