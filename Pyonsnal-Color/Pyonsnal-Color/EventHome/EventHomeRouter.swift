//
//  EventHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol EventHomeInteractable: Interactable,
                                EventDetailListener,
                                ProductDetailListener {
    var router: EventHomeRouting? { get set }
    var listener: EventHomeListener? { get set }
}

protocol EventHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class EventHomeRouter: ViewableRouter<EventHomeInteractable, EventHomeViewControllable>,
                             EventHomeRouting {

    private let eventDetailBuilder: EventDetailBuilder
    private let productDetail: ProductDetailBuildable
    
    private var eventDetailRouting: ViewableRouting?
    private var productDetailRouting: ProductDetailRouting?

    init(
        interactor: EventHomeInteractable,
        viewController: EventHomeViewControllable,
        eventDetailBuilder: EventDetailBuilder,
        productDetail: ProductDetailBuildable
    ) {
        self.eventDetailBuilder = eventDetailBuilder
        self.productDetail = productDetail
        super.init(interactor: interactor,
                   viewController: viewController)
        interactor.router = self
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
    
    func attachProductDetail(with product: ProductConvertable) {
        if productDetailRouting != nil { return }
        
        let productDetailRouter = productDetail.build(withListener: interactor)
        productDetailRouting = productDetailRouter
        attachChild(productDetailRouter)
        let productDetailViewController = productDetailRouting?.viewControllable as? ProductDetailViewController
        productDetailViewController?.product = product
        viewControllable.pushViewController(productDetailRouter.viewControllable, animated: true)
    }
    
    func detachProductDetail() {
        guard let productDetailRouting else { return }
        viewController.popViewController(animated: true)
        self.productDetailRouting = nil
        detachChild(productDetailRouting)
    }
}
