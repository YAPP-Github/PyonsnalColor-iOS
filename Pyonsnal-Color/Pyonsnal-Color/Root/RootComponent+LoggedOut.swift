//
//  RootComponent+LoggedOut.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/29.
//

import ModernRIBs

protocol RootDependencyLoggedOut: Dependency {
}

extension RootComponent: LoggedOutDependency {
    var kakaoLoginService: KakaoLoginService {
        .init()
    }
}
