//
//  ProductAPI.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import Foundation
import Alamofire

enum ProductAPI: NetworkRequestBuilder {
    
    case brandProduct(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore
    )
    case eventProduct(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore
    )
    case eventBanner(storeType: ConvenienceStore)
}

extension ProductAPI {
    
    var urlString: String { Config.shared.baseURLString }
    
    var method: HTTPMethod {
        switch self {
        case .brandProduct, .eventProduct, .eventBanner:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .brandProduct:
            return "/products/pb-products"
        case .eventProduct:
            return "/products/event-products"
        case .eventBanner:
            return "/promotions"
        }
    }
    
    var body: [String: Any]? { nil }
    
    var queryItems: [URLQueryItem]? {
        var queryItems: [URLQueryItem] = []
        
        switch self {
        case let .brandProduct(pageNumber, pageSize, storeType):
            queryItems.append(URLQueryItem(name: "pageNumber", value: "\(pageNumber)"))
            queryItems.append(URLQueryItem(name: "pageSize", value: "\(pageSize)"))
            queryItems.append(URLQueryItem(name: "storeType", value: "\(storeType.rawValue)"))
        case let .eventProduct(pageNumber, pageSize, storeType):
            queryItems.append(URLQueryItem(name: "pageNumber", value: "\(pageNumber)"))
            queryItems.append(URLQueryItem(name: "pageSize", value: "\(pageSize)"))
            queryItems.append(URLQueryItem(name: "storeType", value: "\(storeType.rawValue)"))
        case let .eventBanner(storeType):
            queryItems.append(URLQueryItem(name: "storeType", value: "\(storeType.rawValue)"))
        }
        
        return queryItems
    }

    var headers: [HTTPHeader]? { Config.shared.getDefaultHeader() }
}
