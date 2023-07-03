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
    
    // MARK: - Private
    private init() {}
    
    private let defaultHeaders: [HTTPHeader] = [
        HTTPHeader(name: "Content-Type", value: "application/json"),
        HTTPHeader(name: "Accept", value: "*/*")
    ]
    
    private var headers: [HTTPHeader]?
    
    private func setDefaultHeader() {
        self.headers = defaultHeaders
    }
    
    // MARK: - Shared
    let baseURLString = "http://13.124.33.214:8080"
    
    func setHeaders(headers: [HTTPHeader]) {
        setDefaultHeader()
        self.headers? += headers
    }
    
    func getDefaultHeader() -> [HTTPHeader]? {
        setDefaultHeader()
        return headers
    }
}
