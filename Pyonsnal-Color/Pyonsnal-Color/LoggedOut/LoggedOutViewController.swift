//
//  LoggedOutViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/28.
//

import FirebaseAnalytics
import KakaoSDKUser
import UIKit
import ModernRIBs
import AuthenticationServices

protocol LoggedOutPresentableListener: AnyObject {
    func didTapAppleLoginButton()
    func requestKakaoLogin()
}

final class LoggedOutViewController:
    UIViewController,
    LoggedOutPresentable,
    LoggedOutViewControllable {

    // MARK: - Interface
    weak var listener: LoggedOutPresentableListener?
    private let viewHolder: ViewHolder = .init()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)

        configureUI()
        configureAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "social_login"
        ])
    }

    // MARK: - Private Method
    private func configureUI() {
        view.backgroundColor = .white
    }

    private func configureAction() {
        viewHolder.appleLoginButton.addTarget(
            self,
            action: #selector(didTapAppleLoginButton),
            for: .touchUpInside)

        viewHolder.kakaoLoginButton.addTarget(
            self,
            action: #selector(didTapKakaoLoginButton),
            for: .touchUpInside
        )
    }

    @objc
    private func didTapAppleLoginButton() {
        listener?.didTapAppleLoginButton()
    }

    @objc
    private func didTapKakaoLoginButton() {
        listener?.requestKakaoLogin()
    }

}
