//
//  FavoriteAPI.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/16.
//

import Foundation
import Alamofire

enum FavoriteAPI: NetworkRequestBuilder {
    static var accessToken: String?
    
    case favorites(pageNumber: Int, pageSize: Int, productType: ProductType)
    case addFavorites(productId: String, productType: ProductType)
    case deleteFavorites(favoriteId: String)
}

extension FavoriteAPI {
    var urlString: String {
        return Config.shared.baseURLString
    }
    
    var path: String {
        switch self {
        case .favorites:
            return "/favorites"
        case .addFavorites:
            return "/favorites"
        case .deleteFavorites(let favoriteId):
            return "/favorites/\(favoriteId)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        var queryItems: [URLQueryItem] = []
        switch self {
        case let .favorites(pageNumber, pageSize, productType):
            queryItems.append(URLQueryItem(name: "pageNumber", value: "\(pageNumber)"))
            queryItems.append(URLQueryItem(name: "pageSize", value: "\(pageSize)"))
            queryItems.append(URLQueryItem(name: "productType", value: "\(productType.rawValue)"))
        case .addFavorites:
            return nil
        case .deleteFavorites:
            return nil
        }
        return queryItems
    }
    
    var method: HTTPMethod {
        switch self {
        case .favorites:
            return .get
        case .addFavorites:
            return .post
        case .deleteFavorites:
            return .delete
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case let .addFavorites(productId, productType):
            return ["productId": productId, "productType": productType.rawValue]
        case .favorites, .deleteFavorites:
            return nil
        }
    }
    
    var headers: [Alamofire.HTTPHeader]? {
        if let accessToken = FavoriteAPI.accessToken {
            return Config.shared.getAuthorizationHeader(with: accessToken)
        }
        return Config.shared.getDefaultHeader()
    }
}
