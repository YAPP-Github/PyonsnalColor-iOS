//
//  NetworkError.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case response(ErrorResponse)
    case unknown
}
