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
    
    func uploadReview(
        _ review: ReviewUploadEntity,
        image: UIImage?,
        productId: String,
        completion: @escaping () -> Void
    ) {
        client.upload({ formData in
            let encoder = JSONEncoder()
            guard let reviewData = try? encoder.encode(review) else { return }
            
            formData.append(reviewData, withName: "reviewDto", mimeType: "application/json")
            if let imageData = image?.jpegData(compressionQuality: 1) {
                formData.append(
                    imageData,
                    withName: "imageFile",
                    fileName: "image.jpeg",
                    mimeType: "image/jpeg"
                )
            }
        }, request: ProductAPI.pbReview(id: productId)) { result in
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                Log.n(message: "error: \(error)")
            }
        }
    }
}
