//
//  AppComponent.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/28.
//

import ModernRIBs

final class AppComponent: Component<EmptyDependency>, RootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
