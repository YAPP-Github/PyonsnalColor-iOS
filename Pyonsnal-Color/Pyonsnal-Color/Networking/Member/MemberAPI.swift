//
//  MemberAPI.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/08.
//

import Foundation
import Alamofire

enum MemberAPI: NetworkRequestBuilder {
    case info
    case withdraw
    case logout
}

extension MemberAPI {
    var urlString: String {
        return Config.shared.baseURLString
    }
    
    var path: String {
        switch self {
        case .info:
            return "/info"
        case .withdraw:
            return "/withdraw"
        case .logout:
            return "/logout"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .logout:
            return [URLQueryItem(name: "tokenDto", value: "accessTokenTemp")]
        case .info, .withdraw:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .info:
            return .get
        case .withdraw, .logout:
            return .delete
        }
    }
    
    var headers: [HTTPHeader]? {
        let accessTokenHeader: [HTTPHeader] = [HTTPHeader(name: "Content-Type", value: "Bearer accessToken")]
        Config.shared.setHeaders(headers: accessTokenHeader)
        return Config.shared.getHeader()
    }
    
    var body: [String : Any]? {
        return nil
    }
}
