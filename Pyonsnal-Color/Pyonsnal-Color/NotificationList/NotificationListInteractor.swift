//
//  NotificationListInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/27.
//

import ModernRIBs

protocol NotificationListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol NotificationListPresentable: Presentable {
    var listener: NotificationListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol NotificationListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class NotificationListInteractor: PresentableInteractor<NotificationListPresentable>, NotificationListInteractable, NotificationListPresentableListener {

    weak var router: NotificationListRouting?
    weak var listener: NotificationListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: NotificationListPresentable) {
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
}
