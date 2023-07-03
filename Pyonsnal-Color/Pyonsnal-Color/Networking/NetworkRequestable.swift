//
//  NetworkRequest.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import Foundation
import Combine
import Alamofire

protocol NetworkRequestable {
    func request<T: Decodable>(_ urlRequest: DefaultNetworkBuildable, model: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never>
}
