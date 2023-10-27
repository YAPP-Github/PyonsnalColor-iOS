//
//  FavoriteAPIService.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/16.
//

import Foundation
import Combine
import Alamofire

final class FavoriteAPIService {
    // MARK: - Private Property
    private let client: PyonsnalColorClient
    private let userAuthService: UserAuthService
    private var accessToken: String?
    
    // MARK: - Initializer
    init(client: PyonsnalColorClient, userAuthService: UserAuthService) {
        self.client = client
        self.userAuthService = userAuthService
        self.accessToken = userAuthService.getAccessToken()
    }
    
    // MARK: - Interface
    func addFavorite(
        productId: String,
        productType: ProductType
    ) -> ResponsePublisher<EmptyResponse> {
        FavoriteAPI.accessToken = self.accessToken
        return client.request(
            FavoriteAPI.addFavorites(productId: productId, productType: productType),
            model: EmptyResponse.self
        )
    }
    
    func deleteFavorite(productId: String, productType: ProductType) -> ResponsePublisher<EmptyResponse> {
        FavoriteAPI.accessToken = self.accessToken
        return client.request(
            FavoriteAPI.deleteFavorites(productId: productId, productType: productType),
            model: EmptyResponse.self
        )
    }
    
    func favorites(
        pageNumber: Int,
        pageSize: Int,
        productType: ProductType
    ) -> AnyPublisher<DataResponse<ProductPageEntity, NetworkError>, Never> {
        FavoriteAPI.accessToken = self.accessToken
        return client.request(
            FavoriteAPI.favorites(pageNumber: pageNumber, pageSize: pageSize, productType: productType),
            model: ProductPageEntity.self
        )
    }

}
