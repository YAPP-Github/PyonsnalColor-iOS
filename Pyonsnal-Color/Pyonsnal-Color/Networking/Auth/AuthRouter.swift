//
//  AuthRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/06.
//

import Foundation
import Alamofire

enum AuthRouter: URLRequestConvertible {
    case apple(token: String)

    private var baseURLString: String {
        return ""
    }

    private var method: HTTPMethod {
        switch self {
        case .apple:
            return .post
        }
    }

    private var path: String {
        switch self {
        case .apple:
            return "/auth/apple"
        }
    }

    private var bodyData: Data? {
        switch self {
        case let .apple(token):
            let body: [String: String] = ["token": token]
            let data = try? JSONEncoder().encode(body)
            return data
        }
    }

    private var queryString: [URLQueryItem] {
        switch self {
        case .apple:
            return []
        }
    }

    private var header: [String: String] {
        switch self {
        case .apple:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        // Set URL
        var urlComponent: URLComponents? = .init(string: baseURLString + path)
        if !queryString.isEmpty {
            urlComponent?.queryItems = queryString
        }
        guard let url: URL = urlComponent?.url else {
            fatalError("asURLRequest() - URL get fail")
        }
        var request: URLRequest = .init(url: url)

        // Set Method
        request.method = method

        // Set Header
        header.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Set Body
        if let bodyData {
            request.httpBody = bodyData
        }

        return request
    }
}
