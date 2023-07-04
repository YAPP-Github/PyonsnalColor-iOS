//
//  LoginResponseEntity.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import Foundation

struct LoginResponseEntity: Decodable {
    var isFirstLogin: Bool? //최초 로그인시만 true
    var accessToken: String?
    var refreshToken: String?
}
