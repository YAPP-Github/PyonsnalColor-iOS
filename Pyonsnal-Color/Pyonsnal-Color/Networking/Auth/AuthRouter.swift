//
//  AuthRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/06.
//

import Foundation
import Alamofire

enum AuthRouter: NetworkRequestBuilder {
    case login(token: String, authType: AuthType)
    case guestLogin
    case loginStatus(token: String, authType: AuthType)
    case reissue(userAuth: UserAuthEntity)
}

extension AuthRouter {
    var urlString: String {
        return Config.shared.baseURLString
    }

    var method: HTTPMethod {
        switch self {
        case .login, .loginStatus, .reissue, .guestLogin:
            return .post
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .guestLogin:
            return "/auth/guest/login"
        case .loginStatus:
            return "/auth/status"
        case .reissue:
            return "/auth/reissue"
        }
    }

    var body: [String: Any]? {
        switch self {
        case .login(let token, let authType), .loginStatus(let token, let authType):
            return ["token": token, "oauthType": authType.rawValue]
        case .reissue(let userAuth):
            return [
                "accessToken": userAuth.accessToken,
                "refreshToken": userAuth.refreshToken
            ]
        case .guestLogin:
            return nil
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }

    var headers: [HTTPHeader]? {
        switch self {
        case .login, .loginStatus, .reissue, .guestLogin:
            return Config.shared.getDefaultHeader()
        }
    }
}
