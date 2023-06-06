//
//  KakaoLoginService.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/06.
//

import Foundation
import KakaoSDKUser

protocol KakaoLoginServiceDelegate {
    func didReceive(accessToken: String, refreshToken: String)
}

final class KakaoLoginService: NSObject {
    
    var delegate: KakaoLoginServiceDelegate?
    
    func requestKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    if let accessToken = oauthToken?.accessToken,
                       let refreshToken = oauthToken?.refreshToken {
                        self.delegate?.didReceive(
                            accessToken: accessToken,
                            refreshToken: refreshToken
                        )
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    if let accessToken = oauthToken?.accessToken,
                       let refreshToken = oauthToken?.refreshToken {
                        self.delegate?.didReceive(
                            accessToken: accessToken,
                            refreshToken: refreshToken
                        )
                    }
                }
            }
        }
    }
}
