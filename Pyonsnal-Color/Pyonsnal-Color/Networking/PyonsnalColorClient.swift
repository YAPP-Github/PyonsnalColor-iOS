//
//  PyonsnalColorClient.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import Foundation
import Combine
import Alamofire

typealias ResponsePublisher<T: Decodable> = AnyPublisher<DataResponse<T, NetworkError>, Never>

final class PyonsnalColorClient: NetworkRequestable {
    // MARK: - Private Property
    private let decoder = JSONDecoder()
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func request<T: Decodable>(
        _ urlRequest: NetworkRequestBuilder,
        model: T.Type
    ) -> ResponsePublisher<T> {
        return AF.request(urlRequest)
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { _ in
                    if let curlString = response.request?.curlString {
                        print("Request curl: \(curlString)")
                    } else {
                        print("Request curl: nil")
                    }
                    guard let responseData = response.data else {
                        return NetworkError.emptyResponse
                    }
                    let responseError = try? self.decoder.decode(ErrorResponse.self, from: responseData)
                    if let responseError {
                        dump(responseError)
                        return NetworkError.response(responseError)
                    } else if let responseDataString = String(data: responseData, encoding: .utf8) {
                        print("Response Body: \(responseDataString)")
                        return NetworkError.response(.init(code: nil, message: nil, bodyString: responseDataString))
                    } else {
                        return NetworkError.unknown
                    }
                }
            }.eraseToAnyPublisher()
    }
}
