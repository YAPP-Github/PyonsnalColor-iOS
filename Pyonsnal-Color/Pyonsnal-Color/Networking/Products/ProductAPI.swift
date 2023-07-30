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
        storeType: ConvenienceStore,
        filterList: [String]
    )
    case eventProduct(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore,
        filterList: [String]
    )
    case eventBanner(storeType: ConvenienceStore)
    case search(
        pageNumber: Int,
        pageSize: Int,
        name: String
    )
    case filter
}

extension ProductAPI {
    
    var urlString: String { Config.shared.baseURLString }
    
    var method: HTTPMethod {
        switch self {
        case .eventBanner, .search, .filter:
            return .get
        case .brandProduct, .eventProduct:
            return .post
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
        case .search:
            return "products/search"
        case .filter:
            return "/products/meta-data"
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .brandProduct(_, _, _, let filterList):
            return ["filterList" : filterList]
        case .eventProduct(_, _, _, let filterList):
            return ["filterList" : filterList]
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        var queryItems: [URLQueryItem] = []
        
        switch self {
        case let .brandProduct(pageNumber, pageSize, storeType, _):
            queryItems.append(URLQueryItem(name: "pageNumber", value: "\(pageNumber)"))
            queryItems.append(URLQueryItem(name: "pageSize", value: "\(pageSize)"))
            queryItems.append(URLQueryItem(name: "storeType", value: "\(storeType.rawValue)"))
        case let .eventProduct(pageNumber, pageSize, storeType, _):
            queryItems.append(URLQueryItem(name: "pageNumber", value: "\(pageNumber)"))
            queryItems.append(URLQueryItem(name: "pageSize", value: "\(pageSize)"))
            queryItems.append(URLQueryItem(name: "storeType", value: "\(storeType.rawValue)"))
        case let .eventBanner(storeType):
            queryItems.append(URLQueryItem(name: "storeType", value: "\(storeType.rawValue)"))
        case let .search(pageNumber, pageSize, name):
            queryItems.append(URLQueryItem(name: "pageNumber", value: "\(pageNumber)"))
            queryItems.append(URLQueryItem(name: "pageSize", value: "\(pageSize)"))
            queryItems.append(URLQueryItem(name: "name", value: "\(name)"))
        case .filter:
            return nil
        }
        
        return queryItems
    }

    var headers: [HTTPHeader]? { Config.shared.getDefaultHeader() }
}
