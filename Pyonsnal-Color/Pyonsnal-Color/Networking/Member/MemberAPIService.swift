//
//  MemberAPIService.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/08.
//

import Foundation
import Alamofire

final class MemberAPIService {
    
    // MARK: - Private Property
    private let client: PyonsnalColorClient
    private let userAuthService: UserAuthService
    private var accessToken: String? {
        return userAuthService.getAccessToken()
    }
    
    // MARK: - Initializer
    init(client: PyonsnalColorClient, userAuthService: UserAuthService) {
        self.client = client
        self.userAuthService = userAuthService
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
    
    func widthraw() -> ResponsePublisher<EmptyResponse> {
        MemberAPI.accessToken = accessToken
        return client.request(
            MemberAPI.withdraw,
            model: EmptyResponse.self
        )
    }
    
    func info() -> ResponsePublisher<MemberInfoEntity> {
        MemberAPI.accessToken = accessToken
        return client.request(
            MemberAPI.info,
            model: MemberInfoEntity.self
        )
    }
    
    func validate(nickname: String) -> ResponsePublisher<EmptyResponse> {
        MemberAPI.accessToken = accessToken
        return client.request(
            MemberAPI.validate(nickname: nickname),
            model: EmptyResponse.self
        )
    }
    
    func editProfile(
        nicknameEntity: NicknameEntity?,
        imageData: Data?,
        completion: @escaping () -> Void
    ) {
        MemberAPI.accessToken = accessToken
        client.upload({ formData in
            if let nicknameEntity {
                guard let nickname = try? JSONEncoder().encode(nicknameEntity) else { return }
                formData.append(nickname, withName: "nicknameRequestDto", mimeType: "application/json")
            }
            if let imageData {
                formData.append(
                    imageData,
                    withName: "imageFile",
                    fileName: "image.jpeg",
                    mimeType: "image/jpeg"
                )
            }
        }, request: MemberAPI.editProfile) { result in
            switch result {
            case .success:
                completion()
            case .failure(let error):
                Log.n(message: "error: \(error)")
            }
        }
    }
}
