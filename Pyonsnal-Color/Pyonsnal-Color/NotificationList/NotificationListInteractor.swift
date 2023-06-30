//
//  NotificationListInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/27.
//

import ModernRIBs

protocol NotificationListRouting: ViewableRouting {
}

protocol NotificationListPresentable: Presentable {
    var listener: NotificationListPresentableListener? { get set }
}

protocol NotificationListListener: AnyObject {
    func notificationListDidTapBackButton()
}

final class NotificationListInteractor: PresentableInteractor<NotificationListPresentable>, NotificationListInteractable, NotificationListPresentableListener {

    weak var router: NotificationListRouting?
    weak var listener: NotificationListListener?
    
    override init(presenter: NotificationListPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTabBackButton() {
        listener?.notificationListDidTapBackButton()
    }
}
