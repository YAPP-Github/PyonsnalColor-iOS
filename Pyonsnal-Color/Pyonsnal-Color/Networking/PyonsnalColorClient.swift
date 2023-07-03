//
//  PyonsnalColorClient.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import Foundation
import Combine
import Alamofire

final class PyonsnalColorClient: NetworkRequest {
    
    static let shared = PyonsnalColorClient()
    
    private init() {}
    private let decoder = JSONDecoder()
    
    func request<T: Decodable>(
        _ urlRequest: NetworkRequestBuilder,
        model: T.Type
    ) -> AnyPublisher<DataResponse<T, NetworkError>, Never> {
        return AF.request(urlRequest)
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { _ in
                    if let errorData = response.data {
                        let errorResponse = try? self.decoder.decode(ErrorResponse.self, from: errorData)
                        // error response로 디코딩 되면
                        if let errorResponse {
                            return NetworkError.response(errorResponse)
                        }
                    }
                    return NetworkError.unknown
                }
            }.eraseToAnyPublisher()
    }
}
