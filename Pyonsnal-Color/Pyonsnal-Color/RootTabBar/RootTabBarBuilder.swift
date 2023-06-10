//
//  RootTabBarBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol RootTabBarDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RootTabBarComponent: Component<RootTabBarDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RootTabBarBuildable: Buildable {
    func build(withListener listener: RootTabBarListener) -> RootTabBarRouting
}

final class RootTabBarBuilder: Builder<RootTabBarDependency>, RootTabBarBuildable {

    override init(dependency: RootTabBarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RootTabBarListener) -> RootTabBarRouting {
        let component = RootTabBarComponent(dependency: dependency)
        let viewController = RootTabBarViewController()
        let interactor = RootTabBarInteractor(presenter: viewController)
        interactor.listener = listener
        return RootTabBarRouter(interactor: interactor, viewController: viewController)
    }
}

