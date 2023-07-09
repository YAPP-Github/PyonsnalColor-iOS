//
//  MemberAPIService.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/08.
//

import Foundation

final class MemberAPIService {
    
    // MARK: - Private Property
    private let client: PyonsnalColorClient
    private let userAuthService: UserAuthService
    private var accessToken: String?
    
    // MARK: - Initializer
    init(client: PyonsnalColorClient, userAuthService: UserAuthService) {
        self.client = client
        self.userAuthService = userAuthService
        self.accessToken = userAuthService.getAccessToken()
    }
    
    // MARK: - Interface
    func logout(
        accessToken: String,
        refreshToken: String
    ) -> ResponsePublisher<EmptyResponse> {
        MemberAPI.accessToken = accessToken
        return client.request(
            MemberAPI.logout(accessToken: accessToken, refreshToken: refreshToken),
            model: EmptyResponse.self
        )
    }
    
    func widthraw() -> ResponsePublisher<WithrawEntity> {
        MemberAPI.accessToken = accessToken
        return client.request(
            MemberAPI.withdraw,
            model: WithrawEntity.self
        )
    }
    
    func info() -> ResponsePublisher<MemberInfoEntity> {
        MemberAPI.accessToken = accessToken
        return client.request(
            MemberAPI.info,
            model: MemberInfoEntity.self
        )
    }
}
