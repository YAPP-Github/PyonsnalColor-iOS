//
//  FavoriteBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs

protocol FavoriteDependency: Dependency {
    var productAPIService: ProductAPIService { get }
    var favoriteAPIService: FavoriteAPIService { get }
}

final class FavoriteComponent: Component<FavoriteDependency>,
                               ProductSearchDependency {
    var productAPIService: ProductAPIService
    var favoriteAPIService: FavoriteAPIService
    
    override init(dependency: FavoriteDependency) {
        self.productAPIService = dependency.productAPIService
        self.favoriteAPIService = dependency.favoriteAPIService
        super.init(dependency: dependency)
    }
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
        let productSearch = ProductSearchBuilder(dependency: component)
        let interactor = FavoriteInteractor(
            presenter: viewController,
            favoriteAPIService: component.favoriteAPIService
        )
        interactor.listener = listener
        return FavoriteRouter(
            interactor: interactor,
            viewController: viewController,
            productSearch: productSearch
        )
    }
}
