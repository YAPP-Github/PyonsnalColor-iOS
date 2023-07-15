//
//  LoggedOutInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/28.
//

import ModernRIBs
import Combine
import Foundation

protocol LoggedOutRouting: ViewableRouting {
    func attachTermsOfUse()
    func detachTermsOfUse()
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
}

protocol LoggedOutListener: AnyObject {
    func routeToLoggedIn()
}

final class LoggedOutInteractor:
    PresentableInteractor<LoggedOutPresentable>,
    LoggedOutInteractable,
    LoggedOutPresentableListener {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?
    
    private var dependency: LoggedOutDependency
    private var cancellable = Set<AnyCancellable>()
    // Legacy...
    enum LoginTask {
        case apple(identifyToken: String)
        case kakao(accessToken: String)
    }
    private var loginTask: LoginTask?
    
    init(presenter: LoggedOutPresentable, dependency: LoggedOutDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
        dependency.appleLoginService.delegate = self
        dependency.kakaoLoginService.delegate = self
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
    
    func requestKakaoLogin() {
        dependency.kakaoLoginService.requestKakaoLogin()
    }
    
    private func requestLogin(with token: String, authType: AuthType) {
        dependency.authClient.login(token: token, authType: authType)
            .sink { [weak self] response in
                if let userAuth = response.value {
                    print("login success: \(userAuth.accessToken)")
                    self?.dependency.userAuthService.setAccessToken(userAuth.accessToken)
                    self?.dependency.userAuthService.setRefreshToken(userAuth.refreshToken)
                    self?.listener?.routeToLoggedIn()
                } else if response.error != nil {
                    // TODO: error handling
                } else {
                    // TODO: error handling
                }
            }.store(in: &cancellable)
    }
    
    private func resumeLoginProcess() {
        if let loginTask {
            switch loginTask {
            case .apple(let identifyToken):
                requestLogin(with: identifyToken, authType: .apple)
            case .kakao(let accessToken):
                requestLogin(with: accessToken, authType: .kakao)
            }
        }
        loginTask = nil
    }
    
    func termsOfUseCloseButtonDidTap() {
        loginTask = nil
        router?.detachTermsOfUse()
    }
    
    func termsOfUseAcceptButtonDidTap() {
        resumeLoginProcess()
    }
    
}

extension LoggedOutInteractor: AppleLoginServiceDelegate {
    func didCompleteWithAuthorization(identifyToken: String) {
        
        loginTask = .apple(identifyToken: identifyToken)
        router?.attachTermsOfUse()
    }
}

extension LoggedOutInteractor: KakaoLoginServiceDelegate {
    func didReceive(accessToken: String) {
        loginTask = .kakao(accessToken: accessToken)
        router?.attachTermsOfUse()
    }
}
