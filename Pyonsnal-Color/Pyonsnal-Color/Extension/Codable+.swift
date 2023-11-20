//
//  Codable+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/20/23.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}

extension Dictionary {
    
    func toJsonString() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            let text = String(data: jsonData, encoding: .utf8)
            return text
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
