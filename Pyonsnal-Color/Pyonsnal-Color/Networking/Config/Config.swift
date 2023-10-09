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
    private var headers: [HTTPHeader]?
    
    private let defaultHeaders: [HTTPHeader] = [
        HTTPHeader(name: "Content-Type", value: "application/json"),
        HTTPHeader(name: "Accept", value: "*/*")
    ]
}

extension Config {
    
    func setHeaders(headers: [HTTPHeader]) {
        setDefaultHeader()
        self.headers? += headers
    }
    
    func getDefaultHeader() -> [HTTPHeader]? {
        setDefaultHeader()
        return headers
    }
    
    func getAuthorizationHeader(with token: String) -> [HTTPHeader]? {
        setDefaultHeader()
        setHeaders(headers: [HTTPHeader(name: "Authorization", value: token)])
        return headers
    }
    
    func getMultipartFormDataHeader(with id: String) -> [HTTPHeader]? {
        let header = HTTPHeader(name: "Content-Type", value: "multipart/form-data; boundary=\(id)")
        self.headers = [header]
        return headers
    }
    
    private func setDefaultHeader() {
        self.headers = []
        self.headers = defaultHeaders
    }
    
}
