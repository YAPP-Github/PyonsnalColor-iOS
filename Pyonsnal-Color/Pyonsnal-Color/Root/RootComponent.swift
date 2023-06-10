//
//  RootComponent.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol RootDependencyLoggedOut: Dependency {
}

final class RootComponent: Component<RootDependency> {
    
    let rootViewController: RootViewController
    var appleLoginService: AppleLoginService
    var kakaoLoginService: KakaoLoginService
    
    init(rootViewController: RootViewController,
         dependency: RootDependency
    ) {
        self.rootViewController = rootViewController
        self.appleLoginService = AppleLoginService()
        self.kakaoLoginService = KakaoLoginService()
        super.init(dependency: dependency)
    }
}

extension RootComponent: LoggedOutDependency {
}

extension RootComponent: LoggedInDependency {
    
    var loggedInViewController: LoggedInViewControllable {
        return rootViewController
    }
}
