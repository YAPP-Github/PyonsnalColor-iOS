//
//  ProductDetailBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs

protocol ProductDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProductDetailComponent: Component<ProductDetailDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProductDetailBuildable: Buildable {
    func build(withListener listener: ProductDetailListener) -> ProductDetailRouting
}

final class ProductDetailBuilder: Builder<ProductDetailDependency>, ProductDetailBuildable {

    override init(dependency: ProductDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductDetailListener) -> ProductDetailRouting {
        let component = ProductDetailComponent(dependency: dependency)
        let viewController = ProductDetailViewController()
        let interactor = ProductDetailInteractor(presenter: viewController)
        interactor.listener = listener
        return ProductDetailRouter(interactor: interactor, viewController: viewController)
    }
}
