//
//  MemberAPI.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/08.
//

import Foundation
import Alamofire

enum MemberAPI: NetworkRequestBuilder {
    static var accessToken: String?
    
    case info
    case withdraw
    case logout(accessToken: String, refreshToken: String)
    case validate(nickname: String)
    case editProfile
}

extension MemberAPI {
    var urlString: String {
        return Config.shared.baseURLString
    }
    
    var path: String {
        switch self {
        case .info:
            return "/member/info"
        case .withdraw:
            return "/member/withdraw"
        case .logout:
            return "/member/logout"
        case .validate:
            return "/member/nickname"
        case .editProfile:
            return "/member/profile"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .logout(let accessToken, _):
            return [URLQueryItem(name: "tokenDto", value: accessToken)]
        case .info, .withdraw, .validate, .editProfile:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .info:
            return .get
        case .withdraw, .logout:
            return .delete
        case .validate:
            return .post
        case .editProfile:
            return .patch
        }
    }
    
    var headers: [HTTPHeader]? {
        if let accessToken = MemberAPI.accessToken {
            switch self {
            case .editProfile:
                return Config.shared.getMultipartFormDataHeader(token: accessToken)
            default:
                return Config.shared.getAuthorizationHeader(with: accessToken)
            }
        }
        return Config.shared.getDefaultHeader()
    }
    
    var body: [String: Any]? {
        switch self {
        case .logout(let accessToken, let refreshToken):
            return ["accessToken": accessToken, "refreshToken": refreshToken]
        case .info, .withdraw:
            return nil
        case .validate(let nickname):
            return ["nickname" : "\(nickname)"]
        case .editProfile:
            return nil
        }
    }
}
