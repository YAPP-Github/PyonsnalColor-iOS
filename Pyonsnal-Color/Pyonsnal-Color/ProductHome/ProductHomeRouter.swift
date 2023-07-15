//
//  ProductHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProductHomeInteractable: Interactable, NotificationListListener, ProductDetailListener {
    var router: ProductHomeRouting? { get set }
    var listener: ProductHomeListener? { get set }
}

protocol ProductHomeViewControllable: ViewControllable {
}

final class ProductHomeRouter:
    ViewableRouter<ProductHomeInteractable, ProductHomeViewControllable>,
    ProductHomeRouting {
    
    private let notificationList: NotificationListBuildable
    private let productDetail: ProductDetailBuildable
    
    private var notificationListRouting: NotificationListRouting?
    private var productDetailRouting: ProductDetailRouting?
    
    init(
        interactor: ProductHomeInteractable,
        viewController: ProductHomeViewControllable,
        notificationList: NotificationListBuildable,
        productDetail: ProductDetailBuildable
    ) {
        self.notificationList = notificationList
        self.productDetail = productDetail
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
    
    func attachProductDetail(with product: ProductConvertable) {
        if productDetailRouting != nil { return }
        
        let productDetailRouter = productDetail.build(withListener: interactor)
        productDetailRouting = productDetailRouter
        attachChild(productDetailRouter)
        (productDetailRouting?.viewControllable as? ProductDetailViewController)?.product = product
        viewControllable.pushViewController(productDetailRouter.viewControllable, animated: true)
    }
    
    func detachProductDetail() {
        guard let productDetailRouting else { return }
        viewController.popViewController(animated: true)
        self.productDetailRouting = nil
        detachChild(productDetailRouting)
    }
}
