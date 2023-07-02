//
//  ProfileHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProfileHomeRouting: ViewableRouting {
    func attachAccountSetting()
    func detachAccountSetting()
}

protocol ProfileHomePresentable: Presentable {
    var listener: ProfileHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProfileHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProfileHomeInteractor: PresentableInteractor<ProfileHomePresentable>,
                                   ProfileHomeInteractable,
                                   ProfileHomePresentableListener {


    weak var router: ProfileHomeRouting?
    weak var listener: ProfileHomeListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ProfileHomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapAccountSetting() {
        router?.attachAccountSetting()
    }
    
    func didTapBackButton() {
        router?.detachAccountSetting()
    }
}
