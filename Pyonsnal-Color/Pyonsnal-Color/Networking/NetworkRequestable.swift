//
//  NetworkRequestable.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import Combine
import Foundation
import Alamofire

protocol NetworkRequestable {
    func request<T: Decodable>(
        _ urlRequest: NetworkRequestBuilder,
        model: T.Type
    ) -> AnyPublisher<DataResponse<T, NetworkError>, Never>
}
