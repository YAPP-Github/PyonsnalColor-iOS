//
//  AuthRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/06.
//

import Foundation
import Alamofire

enum AuthRouter: NetworkRequestBuilder {
    case apple(token: String)
    case kakao(accessToken: String)
    case reissue(userAuth: UserAuthEntity)
}

extension AuthRouter {
    var urlString: String {
        return Config.shared.baseURLString
    }

    var method: HTTPMethod {
        switch self {
        case .apple, .kakao, .reissue:
            return .post
        }
    }

    var path: String {
        switch self {
        case .apple:
            return "/auth/apple"
        case .kakao:
            return "/auth/kakao"
        case .reissue:
            return "/auth/reissue"
        }
    }

    var body: [String: Any]? {
        switch self {
        case .apple(let token):
            return ["token": token]
        case .kakao(let accessToken):
            return ["token": accessToken]
        case .reissue(let userAuth):
            return [
                "accessToken": userAuth.accessToken,
                "refreshToken": userAuth.refreshToken
            ]
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }

    var headers: [HTTPHeader]? {
        switch self {
        case .apple, .kakao, .reissue:
            return Config.shared.getDefaultHeader()
        }
    }
}
