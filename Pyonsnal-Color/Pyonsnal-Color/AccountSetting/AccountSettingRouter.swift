//
//  AccountSettingRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/28.
//

import ModernRIBs

protocol AccountSettingInteractable: Interactable, LogoutPopupListener {
    var router: AccountSettingRouting? { get set }
    var listener: AccountSettingListener? { get set }
}

protocol AccountSettingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AccountSettingRouter: ViewableRouter<AccountSettingInteractable, AccountSettingViewControllable>, AccountSettingRouting {

    private let logoutPopupBuildable: LogoutPopupBuildable
    private var logoutPopupRouting: LogoutPopupRouting?
    
    init(
        interactor: AccountSettingInteractable,
        viewController: AccountSettingViewControllable,
        logoutPopupBuilder: LogoutPopupBuildable
    ) {
        self.logoutPopupBuildable = logoutPopupBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachPopup(isLogout: Bool) {
        guard logoutPopupRouting == nil else { return }
        
        let logoutPopupRouter = logoutPopupBuildable.build(
            withListener: interactor,
            isLogout: isLogout
        )
        self.logoutPopupRouting = logoutPopupRouter
        attachChild(logoutPopupRouter)
        let logoutPopup = logoutPopupRouter.viewControllable.uiviewController
        logoutPopup.modalPresentationStyle = .overFullScreen
        viewController.uiviewController.present(logoutPopup, animated: false)
    }
    
    func detachPopup() {
        guard let logoutPopupRouting else { return }
        
        viewControllable.uiviewController.dismiss(animated: false)
        detachChild(logoutPopupRouting)
        self.logoutPopupRouting = nil
    }
}
