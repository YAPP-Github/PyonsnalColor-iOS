//
//  StarRatingReviewBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol StarRatingReviewDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class StarRatingReviewComponent: Component<StarRatingReviewDependency>, DetailReviewDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol StarRatingReviewBuildable: Buildable {
    func build(withListener listener: StarRatingReviewListener) -> StarRatingReviewRouting
}

final class StarRatingReviewBuilder: Builder<StarRatingReviewDependency>, StarRatingReviewBuildable {

    override init(dependency: StarRatingReviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: StarRatingReviewListener) -> StarRatingReviewRouting {
        let component = StarRatingReviewComponent(dependency: dependency)
        let viewController = StarRatingReviewViewController()
        let interactor = StarRatingReviewInteractor(presenter: viewController)
        let detailReviewBuilder = DetailReviewBuilder(dependency: component)
        interactor.listener = listener
        return StarRatingReviewRouter(
            interactor: interactor,
            viewController: viewController,
            detailReviewBuilder: detailReviewBuilder
        )
    }
}
