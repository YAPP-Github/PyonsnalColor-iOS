//
//  ProductAPIService.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import Alamofire
import Combine

final class ProductAPIService {
    
    private let client: PyonsnalColorClient
    
    init(client: PyonsnalColorClient) {
        self.client = client
    }
    
    func requestBrandProduct(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore
    ) -> AnyPublisher<DataResponse<ProductPageEntity<BrandProductEntity>, NetworkError>, Never> {
        return client.request(
            ProductAPI.brandProduct(pageNumber: pageNumber, pageSize: pageSize, storeType: storeType),
            model: ProductPageEntity.self
        )
    }
    
    func requestEventProduct(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore = .all
    ) -> AnyPublisher<DataResponse<ProductPageEntity<EventProductEntity>, NetworkError>, Never> {
        return client.request(
            ProductAPI.eventProduct(pageNumber: pageNumber, pageSize: pageSize, storeType: storeType),
            model: ProductPageEntity.self
        )
    }
}
