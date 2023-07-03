//
//  ProductHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProductHomeRouting: ViewableRouting {
    func attachNotificationList()
    func detachNotificationList()
}

protocol ProductHomePresentable: Presentable {
    var listener: ProductHomePresentableListener? { get set }
}

protocol ProductHomeListener: AnyObject {
}

final class ProductHomeInteractor: PresentableInteractor<ProductHomePresentable>, ProductHomeInteractable, ProductHomePresentableListener {

    weak var router: ProductHomeRouting?
    weak var listener: ProductHomeListener?

    override init(presenter: ProductHomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapNotificationButton() {
        router?.attachNotificationList()
    }
    
    func notificationListDidTapBackButton() {
        router?.detachNotificationList()
    }
}
