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
    
    init(rootViewController: RootViewController,
         dependency: RootDependency
    ) {
        self.rootViewController = rootViewController
        self.appleLoginService = AppleLoginService()
        super.init(dependency: dependency)
    }
}

extension RootComponent: LoggedOutDependency {
    
    var kakaoLoginService: KakaoLoginService {
        .init()
    }
}

extension RootComponent: LoggedInDependency {
    
    var loggedInViewController: LoggedInViewControllable {
        return rootViewController
    }
}
