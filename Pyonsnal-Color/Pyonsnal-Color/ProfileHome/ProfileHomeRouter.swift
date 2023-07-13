//
//  ProfileHomeRouter.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProfileHomeInteractable: Interactable,
                                  AccountSettingListener,
                                  CommonWebListener {
    var router: ProfileHomeRouting? { get set }
    var listener: ProfileHomeListener? { get set }
}

protocol ProfileHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileHomeRouter: ViewableRouter<ProfileHomeInteractable,
                               ProfileHomeViewControllable>,
                               ProfileHomeRouting {
    
    private let commonWebBuilder: CommonWebBuildable
    private var commonWebRouting: ViewableRouting?
    
    private let accountSettingBuilder: AccountSettingBuildable
    private var accountSetting: ViewableRouting?

    init(
        interactor: ProfileHomeInteractable,
        viewController: ProfileHomeViewControllable,
        accountSettingBuilder: AccountSettingBuildable,
        commonWebBuilder: CommonWebBuilder
    ) {
        self.accountSettingBuilder = accountSettingBuilder
        self.commonWebBuilder = commonWebBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAccountSetting() {
        if accountSetting != nil { return }
        
        let accountSettingRouter = accountSettingBuilder.build(withListener: interactor)
        accountSetting = accountSettingRouter
        attachChild(accountSettingRouter)
        viewController.pushViewController(accountSettingRouter.viewControllable, animated: true)
    }
    
    func detachAccountSetting() {
        guard let accountSetting else { return }
        viewController.popViewController(animated: true)
        self.accountSetting = nil
        detachChild(accountSetting)
    }
    
    func attachCommonWebView(with settingInfo: SettingInfo) {
        if commonWebRouting != nil { return }
        let commonWebBuilder = commonWebBuilder.build(
            withListener: interactor,
            settingInfo: settingInfo
        )
        self.commonWebRouting = commonWebBuilder
        attachChild(commonWebBuilder)
        commonWebBuilder.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(commonWebBuilder.viewControllable.uiviewController,
                                                animated: true)
    }

    func detachCommonWebView() {
        guard let commonWebRouting else { return }
        self.commonWebRouting = nil
        detachChild(commonWebRouting)
        viewController.uiviewController.dismiss(animated: true)
    }
    
}
