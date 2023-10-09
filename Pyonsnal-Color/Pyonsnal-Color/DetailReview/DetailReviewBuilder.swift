//
//  DetailReviewBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import ModernRIBs

protocol DetailReviewDependency: Dependency {
}

final class DetailReviewComponent: Component<DetailReviewDependency>, ReviewPopupDependency {
    let pyonsnalColorClient = PyonsnalColorClient()
    let userAuthService = UserAuthService(keyChainService: .shared)
    
    var productAPIService: ProductAPIService {
        return ProductAPIService(client: pyonsnalColorClient, userAuthService: userAuthService)
    }
    var memberAPIService: MemberAPIService {
        return MemberAPIService(client: pyonsnalColorClient, userAuthService: userAuthService)
    }
}

// MARK: - Builder

protocol DetailReviewBuildable: Buildable {
    func build(withListener listener: DetailReviewListener, score: Int) -> DetailReviewRouting
}

final class DetailReviewBuilder: Builder<DetailReviewDependency>, DetailReviewBuildable {

    override init(dependency: DetailReviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DetailReviewListener, score: Int) -> DetailReviewRouting {
        let component = DetailReviewComponent(dependency: dependency)
        let viewController = DetailReviewViewController(score: score)
        let interactor = DetailReviewInteractor(presenter: viewController, component: component)
        let reviewPopupBuilder = ReviewPopupBuilder(dependency: component)
        interactor.listener = listener
        return DetailReviewRouter(
            interactor: interactor,
            viewController: viewController,
            reviewPopupBuildable: reviewPopupBuilder
        )
    }
}
