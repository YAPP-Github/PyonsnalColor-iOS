//
//  FavoriteBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs

protocol FavoriteDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FavoriteComponent: Component<FavoriteDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FavoriteBuildable: Buildable {
    func build(withListener listener: FavoriteListener) -> FavoriteRouting
}

final class FavoriteBuilder: Builder<FavoriteDependency>, FavoriteBuildable {

    override init(dependency: FavoriteDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FavoriteListener) -> FavoriteRouting {
        let component = FavoriteComponent(dependency: dependency)
        let viewController = FavoriteViewController()
        let interactor = FavoriteInteractor(presenter: viewController)
        interactor.listener = listener
        return FavoriteRouter(interactor: interactor, viewController: viewController)
    }
}
