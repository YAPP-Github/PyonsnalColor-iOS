//
//  AccountSettingRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/28.
//

import ModernRIBs

protocol AccountSettingInteractable: Interactable {
    var router: AccountSettingRouting? { get set }
    var listener: AccountSettingListener? { get set }
}

protocol AccountSettingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AccountSettingRouter: ViewableRouter<AccountSettingInteractable, AccountSettingViewControllable>, AccountSettingRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AccountSettingInteractable, viewController: AccountSettingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
