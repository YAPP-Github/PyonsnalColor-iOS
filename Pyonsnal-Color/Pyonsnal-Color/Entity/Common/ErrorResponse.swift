//
//  ErrorResponse.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import Foundation

struct ErrorResponse: Decodable {
    let code: String?
    let message: String?
    let bodyString: String?
}
