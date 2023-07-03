//
//  NotificationListRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/27.
//

import ModernRIBs

protocol NotificationListInteractable: Interactable {
    var router: NotificationListRouting? { get set }
    var listener: NotificationListListener? { get set }
}

protocol NotificationListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class NotificationListRouter: ViewableRouter<NotificationListInteractable, NotificationListViewControllable>, NotificationListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: NotificationListInteractable, viewController: NotificationListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
