//
//  MyPickBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs

protocol MyPickDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MyPickComponent: Component<MyPickDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MyPickBuildable: Buildable {
    func build(withListener listener: MyPickListener) -> MyPickRouting
}

final class MyPickBuilder: Builder<MyPickDependency>, MyPickBuildable {

    override init(dependency: MyPickDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MyPickListener) -> MyPickRouting {
        let component = MyPickComponent(dependency: dependency)
        let viewController = MyPickViewController()
        let interactor = MyPickInteractor(presenter: viewController)
        interactor.listener = listener
        return MyPickRouter(interactor: interactor, viewController: viewController)
    }
}
