//
//  Config.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/03.
//

import Foundation
import Alamofire

final class Config {
    
    static var shared = Config()
    
    private init() {}
    
    let baseURLString = "https://pyonsnalcolor.store"
    
    private let defaultHeaders: [HTTPHeader] = [
        HTTPHeader(name: "Content-Type", value: "application/json"),
        HTTPHeader(name: "Accept", value: "*/*")
    ]
}

extension Config {
    
    func getDefaultHeader() -> [HTTPHeader]? {
        return defaultHeaders
    }
    
    func getAuthorizationHeader(with token: String) -> [HTTPHeader]? {
        return [HTTPHeader(name: "Authorization", value: token)] + defaultHeaders
    }
    
    func getMultipartFormDataHeader(id: String? = nil, token: String) -> [HTTPHeader]? {
        return [HTTPHeader(name: "Content-Type", value: "multipart/form-data; boundary=\(id ?? "")"),
                HTTPHeader(name: "Authorization", value: token)]
    }
    
}
