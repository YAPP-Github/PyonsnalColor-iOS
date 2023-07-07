//
//  AuthClient.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/08.
//

final class AuthClient {
    
    // MARK: - Private Property
    private let client: PyonsnalColorClient
    
    // MARK: - Initializer
    init(client: PyonsnalColorClient) {
        self.client = client
    }
    
    // MARK: - Interface
    func appleLogin(token: String) -> ResponsePublisher<UserAuthEntity> {
        return client.request(
            AuthRouter.apple(token: token),
            model: UserAuthEntity.self
        )
    }
    
    func kakaoLogin(accessToken: String) -> ResponsePublisher<UserAuthEntity> {
        return client.request(
            AuthRouter.kakao(accessToken: accessToken),
            model: UserAuthEntity.self
        )
    }
    
    func reissue(userAuth: UserAuthEntity) -> ResponsePublisher<UserAuthEntity> {
        return client.request(
            AuthRouter.reissue(userAuth: userAuth),
            model: UserAuthEntity.self
        )
    }
}
