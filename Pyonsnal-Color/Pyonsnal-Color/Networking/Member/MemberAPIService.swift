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
    
    // MARK: - Initializer
    init(client: PyonsnalColorClient) {
        self.client = client
    }
    
    // MARK: - Interface
    func logout() -> ResponsePublisher<EmptyResponse> {
        return client.request(
            MemberAPI.logout,
            model: EmptyResponse.self
        )
    }
    
    func widthraw() -> ResponsePublisher<WithrawEntity> {
        return client.request(
            MemberAPI.withdraw,
            model: WithrawEntity.self
        )
    }
    
    func info() -> ResponsePublisher<MemberInfoEntity> {
        return client.request(
            MemberAPI.info,
            model: MemberInfoEntity.self
        )
    }
}
