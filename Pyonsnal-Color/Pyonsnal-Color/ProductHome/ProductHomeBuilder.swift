//
//  ProductHomeBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProductHomeDependency: Dependency {
    var productAPIService: ProductAPIService { get }
}

final class ProductHomeComponent: Component<ProductHomeDependency>,
                                  ProductSearchDependency,
                                  NotificationListDependency,
                                  ProductDetailDependency,
                                  ProductFilterDependency {
    var productAPIService: ProductAPIService
    
    fileprivate var filterStateManager: FilterStateManager?
    
    override init(dependency: ProductHomeDependency) {
        self.productAPIService = dependency.productAPIService
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ProductHomeBuildable: Buildable {
    func build(withListener listener: ProductHomeListener) -> ProductHomeRouting
}

final class ProductHomeBuilder: Builder<ProductHomeDependency>, ProductHomeBuildable {

    override init(dependency: ProductHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductHomeListener) -> ProductHomeRouting {
        let component = ProductHomeComponent(dependency: dependency)
        let viewController = ProductHomeViewController()
        let interactor = ProductHomeInteractor(
            presenter: viewController,
            productAPIService: component.productAPIService,
            filterStateManager: component.filterStateManager
        )
        
        let productSearch: ProductSearchBuilder = .init(dependency: component)
        let notificationList: NotificationListBuilder = .init(dependency: component)
        let productDetail: ProductDetailBuilder = .init(dependency: component)
        let productFilter: ProductFilterBuilder = .init(dependency: component)
        
        interactor.listener = listener
        return ProductHomeRouter(
            interactor: interactor,
            viewController: viewController,
            productSearch: productSearch,
            notificationList: notificationList,
            productDetail: productDetail,
            productFilter: productFilter
        )
    }
}
