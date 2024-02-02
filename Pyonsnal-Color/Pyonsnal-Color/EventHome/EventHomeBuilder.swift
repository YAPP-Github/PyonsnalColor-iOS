//
//  EventHomeBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol EventHomeDependency: Dependency {
    var productAPIService: ProductAPIService { get }
    var favoriteAPIService: FavoriteAPIService { get }
}

final class EventHomeComponent: Component<EventHomeDependency>,
                                ProductSearchDependency,
                                EventDetailDependency,
                                ProductDetailDependency,
                                ProductFilterDependency,
                                LoginPopupDependency {
    let productAPIService: ProductAPIService
    let favoriteAPIService: FavoriteAPIService
    
    override init(dependency: EventHomeDependency) {
        self.productAPIService = dependency.productAPIService
        self.favoriteAPIService = dependency.favoriteAPIService
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol EventHomeBuildable: Buildable {
    func build(withListener listener: EventHomeListener) -> EventHomeRouting
}

final class EventHomeBuilder: Builder<EventHomeDependency>, EventHomeBuildable {

    override init(dependency: EventHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EventHomeListener) -> EventHomeRouting {
        let component = EventHomeComponent(dependency: dependency)
        let viewController = EventHomeViewController()
        let eventDetailBuilder = EventDetailBuilder(dependency: component)
        let productDetail: ProductDetailBuilder = .init(dependency: component)
        let productFilter: ProductFilterBuilder = .init(dependency: component)
        let loginPopup: LoginPopupBuilder = .init(dependency: component)
        let interactor = EventHomeInteractor(
            presenter: viewController,
            dependency: dependency
        )
        let productSearch: ProductSearchBuilder = .init(dependency: component)
        interactor.listener = listener
        return EventHomeRouter(
            interactor: interactor,
            viewController: viewController,
            productSearch: productSearch,
            eventDetailBuilder: eventDetailBuilder,
            productDetail: productDetail,
            productFilter: productFilter,
            loginPopup: loginPopup
        )
    }
}
