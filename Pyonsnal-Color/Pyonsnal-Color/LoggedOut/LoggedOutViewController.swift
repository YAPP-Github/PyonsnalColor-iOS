//
//  LoggedOutViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/28.
//

import UIKit
import ModernRIBs
import AuthenticationServices

protocol LoggedOutPresentableListener: AnyObject {
}

final class LoggedOutViewController:
    UIViewController,
    LoggedOutPresentable,
    LoggedOutViewControllable {

    // MARK: - Interface
    weak var listener: LoggedOutPresentableListener?

    // MARK: - UI Component
    private let loginButtonStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()

    private let appleLoginButton = ASAuthorizationAppleIDButton()

    private let kakaoLoginButton: UIButton = {
        let button: UIButton = .init()
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBrown
        button.setTitle("🍈 Kakao Login", for: .normal)
        button.setTitleColor(.systemYellow, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return button
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureLayout()
    }

    // MARK: - Private Method
    private func configureUI() {
        view.backgroundColor = .green
        setAppleLoginButton()
    }
    
    private func configureLayout() {
        view.addSubview(loginButtonStackView)

        loginButtonStackView.addArrangedSubview(appleLoginButton)
        loginButtonStackView.addArrangedSubview(kakaoLoginButton)

        NSLayoutConstraint.activate([
            loginButtonStackView.widthAnchor.constraint(equalToConstant: 220),
            loginButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButtonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setAppleLoginButton() {
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton),
                                   for: .touchUpInside)
    }
    
    @objc
    private func didTapAppleLoginButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoggedOutViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            if let authorizationCode = appleIDCredential.authorizationCode, let identifyToken = appleIDCredential.identityToken {
                let authorizationCodeString = String(data: authorizationCode, encoding: .utf8)
                let identifyTokenString = String(data: identifyToken, encoding: .utf8)
            }
            /// TO DO : send to server
            /// TO DO : get token from server
            /// save token to Keychain
            if KeyChainManager.shared.addToken(token: "refreshToken", to: "refreshToken"),  KeyChainManager.shared.addToken(token: "accessToken", to: "accessToken") {
                //routeToHome
            }
            print("\(userIdentifier) \(fullName) \(email)")
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //handle error
        print("error ocurred")
    }
}

extension LoggedOutViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}


