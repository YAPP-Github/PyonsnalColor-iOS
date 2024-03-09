//
//  UserAuthEntity.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/08.
//

struct UserAuthEntity: Codable {
    let isFirstLogin: Bool
    let isGuest: Bool
    let accessToken: String
    let refreshToken: String
}
