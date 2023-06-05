//
//  KeyChainManager.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/03.
//

import Foundation
import Security

//저장할 임시 데이터
enum Token: String {
    case refreshToken
    case accessToken
    case socialType
}

enum SocialType: String {
    case kakao
    case apple
}


final class KeyChainManager: NSObject {
    
    static let shared = KeyChainManager()
    private override init() {}
    
    func addToken(token: String,
                  to key: String) -> Bool {
        guard let tokenData = token.data(using: .utf8) else { return false }
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                               kSecAttrService : key,
                                      //kSecAttrAccount : 아이템 계정 이름,
                             kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
                                 kSecValueData : tokenData]
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getToken(with key: String) -> String? {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                               kSecAttrService : key,
                                 kSecReturnData: true,
                                 kSecMatchLimit: kSecMatchLimitOne]
        
        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data, let value = String(data: data, encoding: .utf8) {
            return value
        }
        return nil
    }
    
    func deleteToken(with key: String) -> Bool {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                               kSecAttrService : key,
                                      //kSecAttrAccount : 아이템 계정 이름,
        ]
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

