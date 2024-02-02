//
//  ProductSearchRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import ModernRIBs

protocol ProductSearchInteractable: Interactable, ProductSearchSortBottomSheetListener, ProductFilterListener, ProductDetailListener, LoginPopupListener {
    var router: ProductSearchRouting? { get set }
    var listener: ProductSearchListener? { get set }
}

protocol ProductSearchViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductSearchRouter: ViewableRouter<ProductSearchInteractable, ProductSearchViewControllable>, ProductSearchRouting {
    
    private let productSearchSortBottomSheet: ProductSearchSortBottomSheetBuildable
    private var productSearchSortBottomSheetRouting: ProductSearchSortBottomSheetRouting?
    
    private let productFilter: ProductFilterBuildable
    private var productFilterRouting: ProductFilterRouting?
    
    private let productDetail: ProductDetailBuildable
    private var productDetailRouting: ProductDetailRouting?
    
    private let loginPopup: LoginPopupBuildable
    private var loginPopupRouting: LoginPopupRouting?

    init(
        interactor: ProductSearchInteractable,
        viewController: ProductSearchViewControllable,
        productSearchSortBottomSheet: ProductSearchSortBottomSheetBuildable,
        productFilter: ProductFilterBuildable,
        productDetail: ProductDetailBuildable,
        loginPopup: LoginPopupBuildable
    ) {
        self.productSearchSortBottomSheet = productSearchSortBottomSheet
        self.productFilter = productFilter
        self.productDetail = productDetail
        self.loginPopup = loginPopup
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSortBottomSheet(with filterItem: FilterItemEntity) {
        guard productSearchSortBottomSheetRouting == nil else { return }
        
        let sortBottomSheetRouter = productSearchSortBottomSheet.build(withListener: interactor)
        (sortBottomSheetRouter.viewControllable.uiviewController as? ProductSearchSortBottomSheetViewController)?.payload = .init()
        attachChild(sortBottomSheetRouter)
        
        viewController.uiviewController.present(
            sortBottomSheetRouter.viewControllable.uiviewController,
            animated: true
        )
    }
    
    func detachSortBottomSheet() {
        guard let productSearchSortBottomSheetRouting else { return }
        
        self.productSearchSortBottomSheetRouting = nil
        detachChild(productSearchSortBottomSheetRouting)
        productSearchSortBottomSheetRouting.viewControllable.uiviewController.dismiss(
            animated: true
        )
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
        viewControllable.uiviewController.present(productFilterViewController, animated: false)
    }
    
    func detachProductFilter() {
        guard let productFilterRouting else { return }
        viewController.uiviewController.dismiss(animated: false)
        self.productFilterRouting = nil
        detachChild(productFilterRouting)
    }
    
    func attachProductDetail(with product: ProductDetailEntity) {
        if productDetailRouting != nil { return }
        
        let productDetailRouter = productDetail.build(withListener: interactor, product: product)
        productDetailRouting = productDetailRouter
        attachChild(productDetailRouter)
        viewControllable.pushViewController(productDetailRouter.viewControllable, animated: true)
    }
    
    func detachProductDetail() {
        guard let productDetailRouting else { return }
        viewController.popViewController(animated: true)
        detachChild(productDetailRouting)
        self.productDetailRouting = nil
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
