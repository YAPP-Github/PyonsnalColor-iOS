//
//  NetworkError.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import UIKit
import Alamofire

enum NetworkError: Error {
    case response(ErrorResponse)
    case emptyResponse
    case unknown
    
    var type: NetworkErrorType {
        switch self {
        case .response(let response):
            return NetworkErrorType(rawValue: response.message ?? "") ?? .unknown
        case .emptyResponse:
            return .emptyResponse
        case .unknown:
            return .unknown
        }
    }
}

enum NetworkErrorType: String {
    // Access Token
    case accessTokenExpired = "Access Token이 만료되었습니다."
    case accessTokenMalformed = "Access Token의 형식이 유효하지 않습니다."
    case accessTokenInvalid = "Access Token이 유효하지 않습니다."
    case accessTokenNotBearer = "Access Token이 Bearer 형식이 아닙니다."
    
    // Refresh Token
    case refreshTokenNotExist = "해당 Refresh Token을 가진 사용자가 없습니다."
    case refreshTokenMismatch = "사용자의 Refresh Token과 일치하지 않습니다."
    case invalidIdOauthId = "해당 OAuth Id을 가진 사용자가 없습니다."
    case memberLogout = "로그아웃된 사용자입니다."
    
    // OAuth
    case oauthUnauthorized = "OAuth 인증에 실패했습니다."
    case emailUnauthorized = "이메일이 유효하지 않습니다."
    
    // 500 - ERROR
    case serverUnavailable = "서버에 오류가 발생하였습니다."
    
    // 앱 내 정의된 error
    case emptyResponse = "응답 값이 null입니다."
    case unknown = "정의되지 않은 오류입니다."
    
    // 닉네임 중복 검사
    case nicknameAlreadyExist = "중복된 닉네임입니다."
    case invalidBlankNickname = "닉네임은 공백이 아닌 값을 입력해주세요."
    case invalidParameter = "닉네임은 특수 문자가 허용되지 않고 15자 이내이어야 합니다."
    case validNickname = "사용 가능한 닉네임입니다."
    
    var textColor: UIColor {
        switch self {
        case .emptyResponse, .validNickname:
            return UIColor.gray600
        default:
            return UIColor.error1
        }
    }
}

