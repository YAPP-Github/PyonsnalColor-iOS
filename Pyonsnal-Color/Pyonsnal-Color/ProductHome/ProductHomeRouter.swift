//
//  ProductHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProductHomeInteractable: Interactable, ProductSearchListener, NotificationListListener, ProductDetailListener, ProductFilterListener {
    var router: ProductHomeRouting? { get set }
    var listener: ProductHomeListener? { get set }
}

protocol ProductHomeViewControllable: ViewControllable {
}

final class ProductHomeRouter:
    ViewableRouter<ProductHomeInteractable, ProductHomeViewControllable>,
    ProductHomeRouting {
    
    private let productSearch: ProductSearchBuildable
    private let notificationList: NotificationListBuildable
    private let productDetail: ProductDetailBuildable
    private let productFilter: ProductFilterBuildable
    
    private var productSearchRouting: ProductSearchRouting?
    private var notificationListRouting: NotificationListRouting?
    private var productDetailRouting: ProductDetailRouting?
    private var productFilterRouting: ProductFilterRouting?
    
    init(
        interactor: ProductHomeInteractable,
        viewController: ProductHomeViewControllable,
        productSearch: ProductSearchBuildable,
        notificationList: NotificationListBuildable,
        productDetail: ProductDetailBuildable,
        productFilter: ProductFilterBuildable
    ) {
        self.productSearch = productSearch
        self.notificationList = notificationList
        self.productDetail = productDetail
        self.productFilter = productFilter
        super.init(interactor: interactor, viewController: viewController)
        
        interactor.router = self
    }
    
    func attachProductSearch() {
        guard productSearchRouting == nil else { return }
        
        let productSearchRouting = productSearch.build(withListener: interactor)
        let viewController = productSearchRouting.viewControllable
        
        viewControllable.pushViewController(
            viewController,
            animated: true
        )
        
        self.productSearchRouting = productSearchRouting
        attachChild(productSearchRouting)
    }
    
    func detachProductSearch() {
        guard let productSearchRouting else { return }
        
        viewControllable.popViewController(animated: true)
        self.productSearchRouting = nil
        detachChild(productSearchRouting)
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
    
    func attachProductFilter(of filter: FilterEntity) {
        guard productFilterRouting == nil else { return }
        
        let productFilterRouter = productFilter.build(
            withListener: interactor,
            filterEntity: filter
        )
        let productFilterViewController = productFilterRouter.viewControllable.uiviewController
        productFilterViewController.modalPresentationStyle = .overFullScreen
        productFilterRouting = productFilterRouter
        attachChild(productFilterRouter)
        viewControllable.uiviewController.present(
            productFilterViewController,
            animated: true
        )
    }
    
    func detachProductFilter() {
        guard let productFilterRouting else { return }
        viewController.uiviewController.dismiss(animated: true)
        self.productFilterRouting = nil
        detachChild(productFilterRouting)
    }
}
