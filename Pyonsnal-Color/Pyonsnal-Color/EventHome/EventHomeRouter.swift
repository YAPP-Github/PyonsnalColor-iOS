//
//  EventHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol EventHomeInteractable: Interactable,
                                ProductSearchListener,
                                EventDetailListener,
                                ProductDetailListener,
                                ProductFilterListener,
                                LoginPopupListener {
    var router: EventHomeRouting? { get set }
    var listener: EventHomeListener? { get set }
}

protocol EventHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class EventHomeRouter: ViewableRouter<EventHomeInteractable, EventHomeViewControllable>,
                             EventHomeRouting {
    
    private let productSearch: ProductSearchBuildable
    private let eventDetailBuilder: EventDetailBuilder
    private let productDetail: ProductDetailBuildable
    private let productFilter: ProductFilterBuildable
    private let loginPopup: LoginPopupBuildable
    
    private var productSearchRouting: ProductSearchRouting?
    private var eventDetailRouting: ViewableRouting?
    private var productDetailRouting: ProductDetailRouting?
    private var productFilterRouting: ProductFilterRouting?
    private var loginPopupRouting: LoginPopupRouting?

    init(
        interactor: EventHomeInteractable,
        viewController: EventHomeViewControllable,
        productSearch: ProductSearchBuildable,
        eventDetailBuilder: EventDetailBuilder,
        productDetail: ProductDetailBuildable,
        productFilter: ProductFilterBuildable,
        loginPopup: LoginPopupBuildable
    ) {
        self.productSearch = productSearch
        self.eventDetailBuilder = eventDetailBuilder
        self.productDetail = productDetail
        self.productFilter = productFilter
        self.loginPopup = loginPopup
        super.init(interactor: interactor,
                   viewController: viewController)
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
    
    func attachEventDetail(with imageURL: String, store: ConvenienceStore) {
        guard eventDetailRouting == nil else { return }
        let eventDetailRouter = eventDetailBuilder.build(
            withListener: interactor,
            imageURL: imageURL,
            store: store
        )
        viewController.pushViewController(
            eventDetailRouter.viewControllable,
            animated: true
        )
        attachChild(eventDetailRouter)
        self.eventDetailRouting = eventDetailRouter
    }
    
    func detachEventDetail() {
        guard let router = eventDetailRouting else { return }
        viewController.popViewController(animated: true)
        self.eventDetailRouting = nil
        detachChild(router)
    }
    
    func attachProductDetail(with product: ProductDetailEntity, filter: FilterEntity) {
        if productDetailRouting != nil { return }
        
        let productDetailRouter = productDetail.build(withListener: interactor, product: product)
        viewControllable.pushViewController(productDetailRouter.viewControllable, animated: true)
        productDetailRouting = productDetailRouter
        attachChild(productDetailRouter)
    }
    
    func detachProductDetail() {
        guard let productDetailRouting else { return }
        viewController.popViewController(animated: true)
        detachChild(productDetailRouting)
        self.productDetailRouting = nil
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
            animated: false
        )
    }
    
    func detachProductFilter() {
        guard let productFilterRouting else { return }
        viewController.uiviewController.dismiss(animated: false)
        detachChild(productFilterRouting)
        self.productFilterRouting = nil
    }
    
    func attachLoginPopup() {
        guard loginPopupRouting == nil else { return }
        
        let loginPopupRouter = loginPopup.build(withListener: interactor)
        let viewController = loginPopupRouter.viewControllable.uiviewController
        
        loginPopupRouting = loginPopupRouter
        attachChild(loginPopupRouter)
        viewController.modalPresentationStyle = .overFullScreen
        viewControllable.uiviewController.present(
            loginPopupRouter.viewControllable.uiviewController,
            animated: false
        )
    }
    
    func detachLoginPopup() {
        guard let loginPopupRouting else { return }
        
        viewControllable.uiviewController.dismiss(animated: false)
        detachChild(loginPopupRouting)
        self.loginPopupRouting = nil
    }
}
