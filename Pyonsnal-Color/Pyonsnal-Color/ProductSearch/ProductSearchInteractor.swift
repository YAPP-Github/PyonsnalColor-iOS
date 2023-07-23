//
//  ProductSearchInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import ModernRIBs
import Combine

protocol ProductSearchRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProductSearchPresentable: Presentable {
    var listener: ProductSearchPresentableListener? { get set }
    
    func presentProducts(with items: [ProductCellType], isCanLoading: Bool)
}

protocol ProductSearchListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func popProductSearch()
}

final class ProductSearchInteractor: PresentableInteractor<ProductSearchPresentable>, ProductSearchInteractable, ProductSearchPresentableListener {

    weak var router: ProductSearchRouting?
    weak var listener: ProductSearchListener?
    
    // MARK: - Private Property
    private let dependency: ProductSearchDependency
    private var cancellable = Set<AnyCancellable>()
    private var keyword: String?
    private var pageNumber: Int = 0
    private let pageSize: Int = 20
    private var isCanLoading: Bool = false
    private var eventProductResult: [EventProductEntity] = [] {
        didSet {
            if eventProductResult.isEmpty {
                presenter.presentProducts(with: [.empty], isCanLoading: isCanLoading)
            } else {
                let items: [ProductCellType] = eventProductResult.map { .item($0) }
                presenter.presentProducts(with: items, isCanLoading: isCanLoading)
            }
        }
    }

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: ProductSearchPresentable,
        dependency: ProductSearchDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func popViewController() {
        listener?.popProductSearch()
    }
    
    func search(with keyword: String?) {
        self.keyword = keyword
        self.pageNumber = 0
        
        if let keyword,
           !keyword.isEmpty {
            dependency.productAPIService.requestSearch(
                pageNumber: pageNumber,
                pageSize: pageSize,
                name: keyword
            )
            .sink { [weak self] response in
                if let productPage = response.value {
                    let isLastPage = self?.pageNumber == (productPage.totalPages - 1)
                    let contentIsEmpty = productPage.content.count == 0
                    self?.isCanLoading = !isLastPage && !contentIsEmpty
                    self?.eventProductResult = productPage.content
                }
            }
            .store(in: &cancellable)
        } else {
            presenter.presentProducts(with: [.empty], isCanLoading: false)
        }
    }
    
    func loadMoreItems() {
        if let keyword,
           !keyword.isEmpty {
            pageNumber += 1
            dependency.productAPIService.requestSearch(
                pageNumber: pageNumber,
                pageSize: pageSize,
                name: keyword
            )
            .sink { [weak self] response in
                if let productPage = response.value {
                    var currentProducts = self?.eventProductResult ?? []
                    let isLastPage = self?.pageNumber == (productPage.totalPages - 1)
                    let contentIsEmpty = productPage.content.count == 0
                    self?.isCanLoading = !isLastPage && !contentIsEmpty
                    currentProducts += productPage.content
                    self?.eventProductResult = currentProducts
                }
            }
            .store(in: &cancellable)
        } else {
            presenter.presentProducts(with: [.empty], isCanLoading: false)
        }
    }
}
