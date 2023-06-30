//
//  ProductHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProductHomeInteractable: Interactable, NotificationListListener {
    var router: ProductHomeRouting? { get set }
    var listener: ProductHomeListener? { get set }
}

protocol ProductHomeViewControllable: ViewControllable {
}

final class ProductHomeRouter:
    ViewableRouter<ProductHomeInteractable, ProductHomeViewControllable>,
    ProductHomeRouting {
    
    private let notificationList: NotificationListBuildable
    private var notificationListRouting: NotificationListRouting?
    
    init(
        interactor: ProductHomeInteractable,
        viewController: ProductHomeViewControllable,
        notificationList: NotificationListBuildable
    ) {
        self.notificationList = notificationList
        super.init(interactor: interactor, viewController: viewController)
        
        interactor.router = self
    }
    
    func attachNotificationList() {
        guard notificationListRouting == nil else { return }
        
        let notificationListRouting = notificationList.build(withListener: interactor)
        let viewController = notificationListRouting.viewControllable.uiviewController
        
        viewController.modalPresentationStyle = .fullScreen
        viewControllable.uiviewController.present(
            viewController,
            animated: true
        )
        
        self.notificationListRouting = notificationListRouting
        attachChild(notificationListRouting)
    }
    
    func detachNotificationList() {
        guard let router = notificationListRouting else { return }
        
        viewControllable.uiviewController.dismiss(animated: true)
        detachChild(router)
        notificationListRouting = nil
    }
}
