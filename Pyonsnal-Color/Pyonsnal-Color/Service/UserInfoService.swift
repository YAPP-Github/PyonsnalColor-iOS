//
//  UserInfoService.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/10/25.
//

import Combine
import AdSupport

final class UserInfoService {
    
    static let shared = UserInfoService()
    
    // MARK: - Private Property
    
    private var memberInfo: MemberInfoEntity?
    private var cancellable = Set<AnyCancellable>()
    
    private let client = PyonsnalColorClient()
    private let userAuthService = UserAuthService(keyChainService: .shared)
    private lazy var memberAPIService = MemberAPIService(client: client, userAuthService: userAuthService)
    
    var memberID: Int? {
        return memberInfo?.memberId
    }
    var adId: String {
        ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    var isGuest: Bool? {
        return memberInfo?.isGuest
    }
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Private Method
    
    func configure() {
        requestMemberInfo()
    }
    
    private func requestMemberInfo() {
        memberAPIService.info()
            .sink { [weak self] response in
                if let memberInfo = response.value {
                    self?.memberInfo = memberInfo
                }
            }
            .store(in: &cancellable)
    }
    
}
