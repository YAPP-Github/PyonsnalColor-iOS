//
//  ProductDetailRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs

protocol ProductDetailInteractable: Interactable, StarRatingReviewListener, ProductFilterListener {
    var router: ProductDetailRouting? { get set }
    var listener: ProductDetailListener? { get set }
}

protocol ProductDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductDetailRouter: ViewableRouter<ProductDetailInteractable, ProductDetailViewControllable>, ProductDetailRouting {
    
    private let productFilter: ProductFilterBuildable
    private var productFilterRouting: ProductFilterRouting?
    private let starRatingReviewBuilder: StarRatingReviewBuildable
    private var starRatingReviewRouting: StarRatingReviewRouting?

    // TODO: Constructor inject child builder protocols to allow building children.

    init(
        interactor: ProductDetailInteractable,
        viewController: ProductDetailViewControllable,
        starRatingReviewBuilder: StarRatingReviewBuildable,
        productFilter: ProductFilterBuildable
    ) {
        self.starRatingReviewBuilder = starRatingReviewBuilder
        self.productFilter = productFilter
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachStarRatingReview(with productDetail: ProductDetailEntity) {
        guard starRatingReviewRouting == nil else { return }
        
        let starRatingReviewRouter = starRatingReviewBuilder.build(
            withListener: interactor,
            productDetail: productDetail
        )
        starRatingReviewRouting = starRatingReviewRouter
        attachChild(starRatingReviewRouter)
        viewController.pushViewController(starRatingReviewRouter.viewControllable, animated: true)
    }
    
    func detachStarRatingReview() {
        guard let starRatingReviewRouting else { return }
        
        viewController.popViewController(animated: true)
        self.starRatingReviewRouting = nil
        detachChild(starRatingReviewRouting)
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
        viewControllable.uiviewController.present(productFilterViewController, animated: true)
    }
    
    func detachProductFilter() {
        guard let productFilterRouting else { return }
        viewController.uiviewController.dismiss(animated: true)
        self.productFilterRouting = nil
        detachChild(productFilterRouting)
    }
}
