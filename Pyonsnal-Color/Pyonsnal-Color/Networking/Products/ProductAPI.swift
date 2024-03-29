//
//  ProductAPI.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import Foundation
import Alamofire

enum ProductAPI: NetworkRequestBuilder {
    static var accessToken: String?
    case brandProduct(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore,
        filterList: [Int]
    )
    case brandDetail(id: String)
    case brandReviewLike(productID: String, reviewID: String, writerID: String)
    case brandReviewHate(productID: String, reviewID: String, writerID: String)
    case eventProduct(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore,
        filterList: [Int]
    )
    case eventBanner(storeType: ConvenienceStore)
    case eventDetail(id: String)
    case eventReviewLike(productID: String, reviewID: String, writerID: String)
    case eventReviewHate(productID: String, reviewID: String, writerID: String)
    case search(
        pageNumber: Int,
        pageSize: Int,
        name: String,
        sortedCode: Int?
    )
    case curationProduct
    case filter
    case pbReview(id: String)
    case eventReview(id: String)
    case homeBanner
}

extension ProductAPI {
    
    var urlString: String { Config.shared.baseURLString }
    
    var method: HTTPMethod {
        switch self {
        case .eventBanner, .search, .filter, .curationProduct, .brandDetail, .eventDetail, .homeBanner:
            return .get
        case .brandProduct, .eventProduct, .pbReview, .eventReview:
            return .post
        case .brandReviewLike, .brandReviewHate, .eventReviewLike, .eventReviewHate:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .brandProduct:
            return "/products/pb-products"
        case .brandDetail(let id):
            return "/products/pb-products/\(id)"
        case .brandReviewLike(let productID, let reviewID, _):
            return "/products/pb-products/\(productID)/reviews/\(reviewID)/like"
        case .brandReviewHate(let productID, let reviewID, _):
            return "/products/pb-products/\(productID)/reviews/\(reviewID)/hate"
        case .eventProduct:
            return "/products/event-products"
        case .eventDetail(let id):
            return "/products/event-products/\(id)"
        case .eventReviewLike(let productID, let reviewID, _):
            return "/products/pb-products/\(productID)/reviews/\(reviewID)/like"
        case .eventReviewHate(let productID, let reviewID, _):
            return "/products/pb-products/\(productID)/reviews/\(reviewID)/hate"
        case .eventBanner:
            return "/promotions"
        case .search:
            return "products/search"
        case .filter:
            return "/products/meta-data"
        case .curationProduct:
            return "products/curation"
        case let .pbReview(id):
            return "/products/pb-products/\(id)/reviews"
        case let .eventReview(id):
            return "/products/event-products/\(id)/reviews"
        case .homeBanner:
            return "/products/home-banner"
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .brandProduct(_, _, _, let filterList):
            return ["filterList": filterList]
        case .eventProduct(_, _, _, let filterList):
            return ["filterList": filterList]
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
        case let .search(pageNumber, pageSize, name, sortedCode):
            queryItems.append(URLQueryItem(name: "pageNumber", value: "\(pageNumber)"))
            queryItems.append(URLQueryItem(name: "pageSize", value: "\(pageSize)"))
            queryItems.append(URLQueryItem(name: "name", value: "\(name)"))
            if let sortedCode {
                queryItems.append(URLQueryItem(name: "sortedCode", value: "\(sortedCode)"))
            }
        case let .brandReviewLike(_, _, writerID):
            queryItems.append(.init(name: "writerId", value: writerID))
        case let .brandReviewHate(_, _, writerID):
            queryItems.append(.init(name: "writerId", value: writerID))
        case let .eventReviewLike(_, _, writerID):
            queryItems.append(.init(name: "writerId", value: writerID))
        case let .eventReviewHate(_, _, writerID):
            queryItems.append(.init(name: "writerId", value: writerID))
        case .curationProduct:
            break
        case .filter, .brandDetail, .eventDetail, .brandReviewLike, .brandReviewHate, .eventReviewLike, .eventReviewHate, .pbReview, .eventReview, .homeBanner:
            return nil
        }
        
        return queryItems
    }
    
    var headers: [HTTPHeader]? {
        if let accessToken = ProductAPI.accessToken {
            switch self {
            case let .pbReview(id), let .eventReview(id):
                return Config.shared.getMultipartFormDataHeader(id: id, token: accessToken)
            default:
                return Config.shared.getAuthorizationHeader(with: accessToken)
            }
        }
        return Config.shared.getDefaultHeader()
    }
}
