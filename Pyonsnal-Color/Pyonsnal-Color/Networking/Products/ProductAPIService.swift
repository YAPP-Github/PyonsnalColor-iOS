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
        storeType: ConvenienceStore,
        filterList: [String]
    ) -> AnyPublisher<DataResponse<ProductPageEntity<BrandProductEntity>, NetworkError>, Never> {
        return client.request(
            ProductAPI.brandProduct(pageNumber: pageNumber, pageSize: pageSize, storeType: storeType, filterList: filterList),
            model: ProductPageEntity.self
        )
    }
    
    func requestEventProduct(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore = .all,
        filterList: [String]
    ) -> AnyPublisher<DataResponse<ProductPageEntity<EventProductEntity>, NetworkError>, Never> {
        return client.request(
            ProductAPI.eventProduct(pageNumber: pageNumber, pageSize: pageSize, storeType: storeType, filterList: filterList),
            model: ProductPageEntity.self
        )
    }
    
    func requestEventBanner(
        storeType: ConvenienceStore
    ) -> AnyPublisher<DataResponse<[EventBannerEntity], NetworkError>, Never> {
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
    ) -> AnyPublisher<DataResponse<ProductPageEntity<EventProductEntity>, NetworkError>, Never> {
        return client.request(
            ProductAPI.search(pageNumber: pageNumber, pageSize: pageSize, name: name, sortedCode: sortedCode),
            model: ProductPageEntity.self
        )
    }
    
    func requestCuration() -> AnyPublisher<DataResponse<CurationProductsEntity, NetworkError>, Never> {
        return client.request(ProductAPI.curationProduct, model: CurationProductsEntity.self)
    }
    
    func requestFilter() -> AnyPublisher<DataResponse<FilterDataEntity, NetworkError>, Never> {
        return client.request(ProductAPI.filter, model: FilterDataEntity.self)
    }
}
