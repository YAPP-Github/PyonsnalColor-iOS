//
//  AuthAPIService.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/08.
//

final class AuthAPIService {
    
    // MARK: - Private Property
    private let client: PyonsnalColorClient
    
    // MARK: - Initializer
    init(client: PyonsnalColorClient) {
        self.client = client
    }
    
    // MARK: - Interface
    func login(token: String, authType: AuthType) -> ResponsePublisher<UserAuthEntity> {
        return client.request(
            AuthRouter.login(token: token, authType: authType),
            model: UserAuthEntity.self
        )
    }
    
    func loginStatus(token: String, authType: AuthType) -> ResponsePublisher<UserLoginStatusEntity> {
        return client.request(
            AuthRouter.loginStatus(token: token, authType: authType),
            model: UserLoginStatusEntity.self
        )
    }
    
    func reissue(userAuth: UserAuthEntity) -> ResponsePublisher<UserAuthEntity> {
        return client.request(
            AuthRouter.reissue(userAuth: userAuth),
            model: UserAuthEntity.self
        )
    }
}
