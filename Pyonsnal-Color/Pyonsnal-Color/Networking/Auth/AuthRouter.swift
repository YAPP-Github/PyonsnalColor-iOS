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
}

extension AuthRouter {
    var urlString: String {
        return Config.shared.baseURLString
    }

    var method: HTTPMethod {
        switch self {
        case .apple:
            return .post
        }
    }

    var path: String {
        switch self {
        case .apple:
            return "/auth/apple"
        }
    }

    var body: [String : Any]? {
        switch self {
        case .apple(let token):
            return ["token" : token]
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }

    var headers: [HTTPHeader]? {
        switch self {
        case .apple:
            return Config.shared.getDefaultHeader()
        }
    }
}
