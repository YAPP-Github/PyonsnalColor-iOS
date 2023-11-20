//
//  PyonsnalColorClient.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import UIKit
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
        if let curlString = urlRequest.urlRequest?.curlString {
            Log.n(message: "Request curl: \(curlString)")
        } else {
            Log.n(message: "Request curl: nil")
        }
        return AF.request(urlRequest)
            .validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { _ in
                    // 데이터 x, 200 ~ 300 -> empty
                    if response.data == nil,
                       let statusCode = response.response?.statusCode,
                       200...300 ~= statusCode {
                        Log.n(message: "success emptyResponse: \(statusCode)")
                        return NetworkError.emptyResponse
                    }
                    // 에러가 발생하면 해당 값으로 디코딩
                    if let data = response.data,
                        let _ = response.error {
                        let responseError = try? self.decoder.decode(ErrorResponse.self, from: data)
                        if let responseError {
                            Log.n(message: "error : \(responseError)")
                            return NetworkError.response(responseError)
                        } else if let responseDataString = String(data: data, encoding: .utf8) {
                            Log.n(message: "Response Body: \(responseDataString)")
                            return NetworkError.response(.init(code: nil, message: nil, bodyString: responseDataString))
                        }
                    }
                    return NetworkError.unknown
                }
            }.eraseToAnyPublisher()
    }
    
    func upload(
        _ closure: @escaping (MultipartFormData) -> Void,
        request: NetworkRequestBuilder,
        completion: @escaping (Result<Void, AFError>) -> Void
    ) {
        AF.upload(multipartFormData: closure, with: request)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    Log.n(message: "\(error)")
                    completion(.failure(error))
                }
            }
    }
}
