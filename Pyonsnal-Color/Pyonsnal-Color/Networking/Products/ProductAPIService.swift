//
//  ProductAPIService.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import UIKit
import Alamofire
import Combine

final class ProductAPIService {
    
    private let client: PyonsnalColorClient
    private let userAuthService: UserAuthService
    private var accessToken: String?
    
    init(client: PyonsnalColorClient, userAuthService: UserAuthService) {
        self.client = client
        self.userAuthService = userAuthService
        self.accessToken = userAuthService.getAccessToken()
    }
    
    func requestBrandProduct(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore,
        filterList: [Int]
    ) -> AnyPublisher<DataResponse<ProductPageEntity, NetworkError>, Never> {
        ProductAPI.accessToken = accessToken
        return client.request(
            ProductAPI.brandProduct(pageNumber: pageNumber, pageSize: pageSize, storeType: storeType, filterList: filterList),
            model: ProductPageEntity.self
        )
    }
    
    func requestBrandProductDetail(
        id: String
    ) -> AnyPublisher<DataResponse<ProductDetailEntity, NetworkError>, Never> {
        ProductAPI.accessToken = accessToken
        return client.request(
            ProductAPI.brandDetail(id: id),
            model: ProductDetailEntity.self
        )
    }
    
    func requestBrandProductReviewLike(
        productID: String,
        reviewID: String
    ) -> AnyPublisher<DataResponse<EmptyResponse, NetworkError>, Never> {
        ProductAPI.accessToken = accessToken
        return client.request(
            ProductAPI.brandReviewLike(productID: productID, reviewID: reviewID),
            model: EmptyResponse.self
        )
    }
    
    func requestBrandProductReviewHate(
        productID: String,
        reviewID: String
    ) -> AnyPublisher<DataResponse<EmptyResponse, NetworkError>, Never> {
        ProductAPI.accessToken = accessToken
        return client.request(
            ProductAPI.brandReviewHate(productID: productID, reviewID: reviewID),
            model: EmptyResponse.self
        )
    }
    
    func requestEventProduct(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore,
        filterList: [Int]
    ) -> AnyPublisher<DataResponse<ProductPageEntity, NetworkError>, Never> {
        ProductAPI.accessToken = accessToken
        return client.request(
            ProductAPI.eventProduct(pageNumber: pageNumber, pageSize: pageSize, storeType: storeType, filterList: filterList),
            model: ProductPageEntity.self
        )
    }
    
    func requestEventProductDetail(
        id: String
    ) -> AnyPublisher<DataResponse<ProductDetailEntity, NetworkError>, Never> {
        ProductAPI.accessToken = accessToken
        return client.request(
            ProductAPI.eventDetail(id: id),
            model: ProductDetailEntity.self
        )
    }
    
    func requestEventProductReviewLike(
        productID: String,
        reviewID: String
    ) -> AnyPublisher<DataResponse<EmptyResponse, NetworkError>, Never> {
        ProductAPI.accessToken = accessToken
        return client.request(
            ProductAPI.eventReviewLike(productID: productID, reviewID: reviewID),
            model: EmptyResponse.self
        )
    }
    
    func requestEventProductReviewHate(
        productID: String,
        reviewID: String
    ) -> AnyPublisher<DataResponse<EmptyResponse, NetworkError>, Never> {
        ProductAPI.accessToken = accessToken
        return client.request(
            ProductAPI.eventReviewHate(productID: productID, reviewID: reviewID),
            model: EmptyResponse.self
        )
    }
    
    func requestEventBanner(
        storeType: ConvenienceStore
    ) -> AnyPublisher<DataResponse<[EventBannerEntity], NetworkError>, Never> {
        ProductAPI.accessToken = accessToken
        return client.request(
            ProductAPI.eventBanner(storeType: storeType),
            model: [EventBannerEntity].self
        )
    }
    
    func requestSearch(
        pageNumber: Int,
        pageSize: Int,
        name: String,
        sortedCode: Int?
    ) -> AnyPublisher<DataResponse<ProductPageEntity, NetworkError>, Never> {
        return client.request(
            ProductAPI.search(pageNumber: pageNumber, pageSize: pageSize, name: name, sortedCode: sortedCode),
            model: ProductPageEntity.self
        )
    }
    
    func requestCuration() -> AnyPublisher<DataResponse<CurationProductsEntity, NetworkError>, Never> {
        ProductAPI.accessToken = accessToken
        return client.request(ProductAPI.curationProduct, model: CurationProductsEntity.self)
    }
    
    func requestFilter() -> AnyPublisher<DataResponse<FilterDataEntity, NetworkError>, Never> {
        return client.request(ProductAPI.filter, model: FilterDataEntity.self)
    }
    
    func uploadReview(_ review: ReviewUploadEntity, image: UIImage?, productId: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let reviewData = try? encoder.encode(review) else { return }
        
        print(String(data: reviewData, encoding: .utf8)!)
        AF.upload(multipartFormData: { formData in
            formData.append(reviewData, withName: "reviewDto", mimeType: "application/json")
            if let imageData = image?.jpegData(compressionQuality: 1) {
                formData.append(
                    imageData,
                    withName: "image",
                    fileName: "\(imageData).jpeg",
                    mimeType: "image/jpeg"
                )
            }
            if let formData = try? formData.encode() {
                print(String(data: formData, encoding: .utf8))
            }
        }, with: ProductAPI.pbReview(id: productId, review: review))
        .response { response in
            response.mapError { _ in
                if let curlString = response.request?.curlString {
                    Log.n(message: "Request curl: \(curlString)")
                } else {
                    Log.n(message: "Request curl: nil")
                }
                guard let responseData = response.data else {
                    Log.n(message: "\(response.error)")
                    return NetworkError.emptyResponse
                }
                let responseError = try? JSONDecoder().decode(ErrorResponse.self, from: responseData)
                if let responseError {
                    Log.n(message: "\(responseError)")
                    return NetworkError.response(responseError)
                } else if let responseDataString = String(data: responseData, encoding: .utf8) {
                    Log.n(message: "Response Body: \(responseDataString)")
                    return NetworkError.response(.init(code: nil, message: nil, bodyString: responseDataString))
                }
                return NetworkError.unknown
            }
        }
    }
}
