//
//  DetailReviewBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import ModernRIBs

protocol DetailReviewDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class DetailReviewComponent: Component<DetailReviewDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol DetailReviewBuildable: Buildable {
    func build(withListener listener: DetailReviewListener) -> DetailReviewRouting
}

final class DetailReviewBuilder: Builder<DetailReviewDependency>, DetailReviewBuildable {

    override init(dependency: DetailReviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DetailReviewListener) -> DetailReviewRouting {
        let component = DetailReviewComponent(dependency: dependency)
        let viewController = DetailReviewViewController()
        let interactor = DetailReviewInteractor(presenter: viewController)
        interactor.listener = listener
        return DetailReviewRouter(interactor: interactor, viewController: viewController)
    }
}
