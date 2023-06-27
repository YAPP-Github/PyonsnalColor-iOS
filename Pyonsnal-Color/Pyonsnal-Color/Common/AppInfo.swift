//
//  AppInfo.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/27.
//

import Foundation

final class AppInfo {
    private init() {}
    static let shared = AppInfo()
    
    var appVersion: String? = {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return appVersion
    }()
    
}
