//
//  ProfileHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProfileHomeInteractable: Interactable,
                                  AccountSettingListener {
    var router: ProfileHomeRouting? { get set }
    var listener: ProfileHomeListener? { get set }
}

protocol ProfileHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileHomeRouter: ViewableRouter<ProfileHomeInteractable,
                               ProfileHomeViewControllable>,
                               ProfileHomeRouting {
    
    private let accountSettingBuilder: AccountSettingBuildable
    private var accountSetting: ViewableRouting?

    init(
        interactor: ProfileHomeInteractable,
        viewController: ProfileHomeViewControllable,
        accountSettingBuilder: AccountSettingBuildable
    ) {
        self.accountSettingBuilder = accountSettingBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAccountSetting() {
        if accountSetting != nil { return }
        
        let accountSettingRouter = accountSettingBuilder.build(withListener: interactor)
        accountSetting = accountSettingRouter
        attachChild(accountSettingRouter)
        let accountSettingViewController = accountSettingRouter.viewControllable.uiviewController
        accountSettingViewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(accountSettingViewController, animated: true)
    }
    
    func detachAccountSetting() {
        guard let accountSetting else { return }
        viewController.uiviewController.dismiss(animated: true)
        self.accountSetting = nil
        detachChild(accountSetting)
    }
    
}
