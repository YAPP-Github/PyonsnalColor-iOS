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
    
    func requestBrandProduct<T: Decodable>(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore = .all
    ) -> AnyPublisher<DataResponse<T, NetworkError>, Never> {
        return client.request(
            ProductAPI.brandProduct(pageNumber: pageNumber, pageSize: pageSize, storeType: storeType),
            model: T.self
        )
    }
    
    func requestEventProduct<T: Decodable>(
        pageNumber: Int,
        pageSize: Int,
        storeType: ConvenienceStore = .all
    ) -> AnyPublisher<DataResponse<T, NetworkError>, Never> {
        return client.request(
            ProductAPI.eventProduct(pageNumber: pageNumber, pageSize: pageSize, storeType: storeType),
            model: T.self
        )
    }
}
