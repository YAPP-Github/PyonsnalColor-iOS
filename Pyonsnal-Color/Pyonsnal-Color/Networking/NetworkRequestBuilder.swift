//
//  NetworkRequestBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import Foundation
import Alamofire

protocol NetworkRequestBuilder: URLRequestConvertible {
    var urlString: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    var headers: [HTTPHeader]? { get }
    var body: [String: Any]? { get }
}

extension NetworkRequestBuilder {
    
    func asURLRequest() throws -> URLRequest {
        let baseURL = try urlString.asURL().appendingPathComponent(path, isDirectory: false)
        var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        // set queryItem
        let urlQueryItems = queryItems?.compactMap { $0 }
        component?.queryItems = urlQueryItems
        
        let requestURL = component?.url ?? baseURL
        var urlRequest = URLRequest(url: requestURL)

        // set method
        urlRequest.httpMethod = method.rawValue
        
        // set body
        if let body {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body,
                                                             options: [])
        }
        
        // set header
        if let headers {
            headers.forEach { header in
                urlRequest.addValue(header.value, forHTTPHeaderField: header.name)
            }
        }
        return urlRequest
    }
}
