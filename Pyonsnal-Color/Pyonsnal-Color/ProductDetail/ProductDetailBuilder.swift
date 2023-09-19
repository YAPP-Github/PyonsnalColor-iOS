//
//  ProductDetailBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs

protocol ProductDetailDependency: Dependency {
    
}

final class ProductDetailComponent: Component<ProductDetailDependency> {

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
        product: any ProductConvertable
    ) -> ProductDetailRouting
}

final class ProductDetailBuilder: Builder<ProductDetailDependency>, ProductDetailBuildable {

    override init(dependency: ProductDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: ProductDetailListener,
        product: any ProductConvertable
    ) -> ProductDetailRouting {
        let component = ProductDetailComponent(dependency: dependency)
        let viewController = ProductDetailViewController()
        let interactor = ProductDetailInteractor(
            presenter: viewController,
            favoriteAPIService: component.favoriteAPIService,
            product: product
        )
        interactor.listener = listener
        return ProductDetailRouter(interactor: interactor, viewController: viewController)
    }
}
