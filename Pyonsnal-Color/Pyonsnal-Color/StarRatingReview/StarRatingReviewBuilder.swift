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
}

// MARK: - Builder

protocol StarRatingReviewBuildable: Buildable {
    func build(
        withListener listener: StarRatingReviewListener,
        productDetail: ProductDetailEntity
    ) -> StarRatingReviewRouting
}

final class StarRatingReviewBuilder: Builder<StarRatingReviewDependency>, StarRatingReviewBuildable {

    override init(dependency: StarRatingReviewDependency) {
        super.init(dependency: dependency)
    }
    
    func build(
        withListener listener: StarRatingReviewListener,
        productDetail: ProductDetailEntity
    ) -> StarRatingReviewRouting {
        let component = StarRatingReviewComponent(dependency: dependency)
        let viewController = StarRatingReviewViewController(productDetail: productDetail)
        let interactor = StarRatingReviewInteractor(
            presenter: viewController,
            productDetail: productDetail
        )
        let detailReviewBuilder = DetailReviewBuilder(dependency: component)
        interactor.listener = listener
        return StarRatingReviewRouter(
            interactor: interactor,
            viewController: viewController,
            detailReviewBuilder: detailReviewBuilder
        )
    }
}
