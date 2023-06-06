//
//  AppleLoginService.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/05.
//

import UIKit
import AuthenticationServices

protocol AppleLoginServiceDelegate: AnyObject {
    func didCompleteWithAuthorization(identifyToken: String)
}

final class AppleLoginService: NSObject {
    
    weak var delegate: AppleLoginServiceDelegate?
    
    func requestAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let identifyToken = appleIDCredential.identityToken,
               let identifyTokenString = String(data: identifyToken,
                                                encoding: .utf8) {
                delegate?.didCompleteWithAuthorization(identifyToken: identifyTokenString)
            }
            
        default:
            break
        }
    }
}

extension AppleLoginService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window ?? UIWindow()
    }
}
