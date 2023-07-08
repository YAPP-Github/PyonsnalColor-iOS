//
//  UserAuthService.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/08.
//

final class UserAuthService {
    
    // MARK: - Private Property
    private let accessTokenKey: String = "UserAuthService.AccessToken.Key"
//    private let refreshTokenKey: String = "UserAuthService.RefreshToken.Key"
    private let keyChainService: KeyChainService
    
    // MARK: - Initializer
    init(keyChainService: KeyChainService) {
        self.keyChainService = keyChainService
    }
    
    // MARK: - Interface
    func getAccessToken() -> String? {
        keyChainService.get(with: accessTokenKey)
    }
    
    func setAccessToken(_ token: String) {
        _ = keyChainService.set(value: token, to: accessTokenKey)
    }
    
//    func refreshToken() -> String? {
//        keyChainService.get(with: refreshTokenKey)
//    }
    
//    func setRefreshToken(_ token: String) {
//        _ = keyChainService.set(value: token, to: refreshTokenKey)
//    }
}
