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
    case addFavorite(productId: String, productType: ProductType)
    case deleteFavorite(productId: String)
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
        case .addFavorite:
            return "/member/favorite"
        case .deleteFavorite:
            return "/member/favorite"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .logout(let accessToken, _):
            return [URLQueryItem(name: "tokenDto", value: accessToken)]
        case .info, .withdraw:
            return nil
        case .addFavorite, .deleteFavorite:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .info:
            return .get
        case .withdraw, .logout, .deleteFavorite:
            return .delete
        case .addFavorite:
            return .post
        }
    }
    
    var headers: [HTTPHeader]? {
        if let accessToken = MemberAPI.accessToken {
            return Config.shared.getAuthorizationHeader(with: accessToken)
        }
        return Config.shared.getDefaultHeader()
    }
    
    var body: [String: Any]? {
        switch self {
        case .logout(let accessToken, let refreshToken):
            return ["accessToken": accessToken, "refreshToken": refreshToken]
        case .info, .withdraw:
            return nil
        case .addFavorite(let productId, let productType):
            return ["productId": productId, "productType": productType.rawValue]
        case .deleteFavorite(let productId):
            return ["productId": productId]
        }
    }
}
