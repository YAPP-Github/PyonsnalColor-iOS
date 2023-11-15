//
//  ProfileHomeInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import Combine

protocol ProfileHomeRouting: ViewableRouting {
    func attachProfileEdit(with memberInfo: MemberInfoEntity)
    func detachProfileEdit()
    
    func attachCommonWebView(with settingInfo: SettingInfo)
    func detachCommonWebView()
    
    func attachAccountSetting()
    func detachAccountSetting()
}

protocol ProfileHomePresentable: Presentable {
    var listener: ProfileHomePresentableListener? { get set }
    func update(with member: MemberInfoEntity)
}

protocol ProfileHomeListener: AnyObject {
    func routeToLoggedOut()
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProfileHomeInteractor: PresentableInteractor<ProfileHomePresentable>,
                                   ProfileHomeInteractable,
                                   ProfileHomePresentableListener {

    weak var router: ProfileHomeRouting?
    weak var listener: ProfileHomeListener?
    private var cancellable = Set<AnyCancellable>()
    private var component: ProfileHomeComponent
    
    init(presenter: ProfileHomePresentable, component: ProfileHomeComponent) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        component.memberAPIService.info()
            .sink { [weak self] response in
                if let memberInfo = response.value {
                    print("info success: \(memberInfo)")
                    self?.presenter.update(with: memberInfo)
                } else if response.error != nil {
                    // TODO: error handling
                } else {
                    // TODO: error handling
                }
            }.store(in: &cancellable)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapAccountSetting() {
        router?.attachAccountSetting()
    }
    
    func didTapTeams(with settingInfo: SettingInfo) {
        router?.attachCommonWebView(with: settingInfo)
    }
    
    func didTapProfileEditButton(memberInfo: MemberInfoEntity) {
        router?.attachProfileEdit(with: memberInfo)
    }
    
    func didTapBackButton() {
        router?.detachAccountSetting()
    }
    
    func routeToLoggedOut() {
        listener?.routeToLoggedOut()
    }
    
    func detachCommonWebView() {
        router?.detachCommonWebView()
    }
}
