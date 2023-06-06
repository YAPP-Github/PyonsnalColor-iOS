//
//  LoggedOutInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/28.
//

import ModernRIBs

protocol LoggedOutRouting: ViewableRouting {
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
}

protocol LoggedOutListener: AnyObject {
}

final class LoggedOutInteractor:
    PresentableInteractor<LoggedOutPresentable>,
    LoggedOutInteractable,
    LoggedOutPresentableListener {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?
    
    private var dependency: LoggedOutDependency

    init(presenter: LoggedOutPresentable, dependency: LoggedOutDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
        dependency.appleLoginService.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapAppleLoginButton() {
        dependency.appleLoginService.requestAppleLogin()
    }
}

extension LoggedOutInteractor: AppleLoginServiceDelegate {
    func didCompleteWithAuthorization(identifyToken: String) {
        /// TO DO : send to server
        /// get token from server
        /// save token to Keychain
        /// route to Home
    }
    
    
    func requestKakaoLogin() {
        dependency.kakaoLoginService.requestKakaoLogin()
    }
}
