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
}

protocol LoggedOutPresentable: Presentable {
    var listener: LoggedOutPresentableListener? { get set }
}

protocol LoggedOutListener: AnyObject {
    func didLogin()
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
        let appleAuthRouter = AuthRouter.apple(token: identifyToken)
        PyonsnalColorClient.shared.request(
            appleAuthRouter,
            model: TokenEntity.self
        )
        .sink { [weak self] response in
            if response.error != nil {
                // error handling
            } else {
                print(response.value)
            }
        }.store(in: &cancellable)
    }
    
}

extension LoggedOutInteractor: AppleLoginServiceDelegate {
    func didCompleteWithAuthorization(identifyToken: String) {
        /// TO DO : send to server
        /// get token from server
        /// save token to Keychain
        
//        listener?.didLogin()
        requestAppleLogin(with: identifyToken)
    }
}

extension LoggedOutInteractor: KakaoLoginServiceDelegate {
    func didReceive(accessToken: String) {
        listener?.didLogin()
    }
}
