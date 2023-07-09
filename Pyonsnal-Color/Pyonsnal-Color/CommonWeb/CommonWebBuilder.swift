//
//  CommonWebBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/07.
//

import ModernRIBs

protocol CommonWebDependency: Dependency {
    
}

final class CommonWebComponent: Component<CommonWebDependency> {
    var subTerms: SubTerms
    
    init(dependency: CommonWebDependency, subTerms: SubTerms) {
        self.subTerms = subTerms
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CommonWebBuildable: Buildable {
    //termsOfUse
    func build(withListener listener: CommonWebListener, subTerms: SubTerms) -> CommonWebRouting
}

final class CommonWebBuilder: Builder<CommonWebDependency>, CommonWebBuildable {
    
    override init(dependency: CommonWebDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: CommonWebListener, subTerms: SubTerms) -> CommonWebRouting {
        let component = CommonWebComponent(dependency: dependency, subTerms: subTerms)
        let viewController = CommonWebViewController()
        let interactor = CommonWebInteractor(presenter: viewController, component: component)
        interactor.listener = listener
        return CommonWebRouter(interactor: interactor,
                               viewController: viewController)
    }
}
