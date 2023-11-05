//
//  ProductDetailBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs

protocol ProductDetailDependency: Dependency {
    var productAPIService: ProductAPIService { get }
}

final class ProductDetailComponent: Component<ProductDetailDependency>, StarRatingReviewDependency {

    fileprivate let favoriteAPIService: FavoriteAPIService
    let client = PyonsnalColorClient()
    let userAuthService = UserAuthService(keyChainService: KeyChainService.shared)
    
    override init(dependency: ProductDetailDependency) {
        self.favoriteAPIService = FavoriteAPIService(client: client, userAuthService: userAuthService)
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ProductDetailBuildable: Buildable {
    func build(
        withListener listener: ProductDetailListener,
        product: ProductDetailEntity
    ) -> ProductDetailRouting
}

final class ProductDetailBuilder: Builder<ProductDetailDependency>, ProductDetailBuildable {

    override init(dependency: ProductDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductDetailListener, product: ProductDetailEntity) -> ProductDetailRouting {
        let component = ProductDetailComponent(dependency: dependency)
        let viewController = ProductDetailViewController()
        let interactor = ProductDetailInteractor(
            presenter: viewController,
            favoriteAPIService: component.favoriteAPIService,
            dependency: dependency,
            product: product
        )
        let starRatingReviewBuilder = StarRatingReviewBuilder(dependency: component)
        interactor.listener = listener
        return ProductDetailRouter(
            interactor: interactor,
            viewController: viewController,
            starRatingReviewBuilder: starRatingReviewBuilder
        )
    }
}
