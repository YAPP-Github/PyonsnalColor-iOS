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
    
    private func requestAppleLogin(with identifyToken: String) {
        dependency.authClient.appleLogin(token: identifyToken)
            .sink { [weak self] response in
                if let userAuth = response.value {
                    print("Apple login success: \(userAuth.accessToken)")
                    self?.router?.attachTermsOfUse()
                } else if response.error != nil {
                    // TODO: error handling
                } else {
                    // TODO: error handling
                }
            }.store(in: &cancellable)
    }
    
    func detachTermsOfUse() {
        router?.detachTermsOfUse()
    }
    
    func routeToLoggedIn() {
        listener?.routeToLoggedIn()
    }
    
}

extension LoggedOutInteractor: AppleLoginServiceDelegate {
    func didCompleteWithAuthorization(identifyToken: String) {
        /// TO DO : send to server
        /// get token from server
        /// save token to Keychain
        
        requestAppleLogin(with: identifyToken)
    }
}

extension LoggedOutInteractor: KakaoLoginServiceDelegate {
    func didReceive(accessToken: String) {
        
        dependency.authClient.kakaoLogin(accessToken: accessToken)
            .sink { [weak self] response in
                if let userAuth = response.value {
                    print("Kakao login success: \(userAuth.accessToken)")
                    self?.router?.attachTermsOfUse()
                } else if let responseError = response.error {
                } else {
                    // TODO: error handling
                }
            }.store(in: &cancellable)
    }
}
