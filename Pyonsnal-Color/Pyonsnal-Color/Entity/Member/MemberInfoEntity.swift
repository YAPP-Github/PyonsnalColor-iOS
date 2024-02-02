//
//  MemberInfoEntity.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/08.
//

import Foundation

struct MemberInfoEntity: Decodable {
    var oauthId: String
    var oauthType: String
    var isGuest: Bool
    var profileImage: String?
    var memberId: Int
    var nickname: String
    var email: String
    var isGuest: Bool
  }
