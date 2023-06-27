//
//  AccountSettingInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/28.
//

import ModernRIBs

protocol AccountSettingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AccountSettingPresentable: Presentable {
    var listener: AccountSettingPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AccountSettingListener: AnyObject {
    func didTapBackButton()
}

final class AccountSettingInteractor: PresentableInteractor<AccountSettingPresentable>, AccountSettingInteractable, AccountSettingPresentableListener {

    weak var router: AccountSettingRouting?
    weak var listener: AccountSettingListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AccountSettingPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
