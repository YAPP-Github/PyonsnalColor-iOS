//
//  ProductSearchInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import ModernRIBs
import Combine

protocol ProductSearchRouting: ViewableRouting {
    func attachSortBottomSheet(with filterItem: FilterItemEntity)
    func detachSortBottomSheet()
    func attachProductFilter(of filter: FilterEntity)
    func detachProductFilter()
}

protocol ProductSearchPresentable: Presentable {
    var listener: ProductSearchPresentableListener? { get set }
    
    func presentProducts(with items: [ProductCellType], isCanLoading: Bool, totalCount: Int, filterItem: FilterItemEntity)
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
    private var filterItem: FilterItemEntity = .init(name: "최신순", code: 0, isSelected: true)
    private var pageNumber: Int = 0
    private let pageSize: Int = 20
    private var isCanLoading: Bool = false
    private var totalCount: Int = 0
    private var eventProductResult: [EventProductEntity] = [] {
        didSet {
            if eventProductResult.isEmpty {
                presenter.presentProducts(
                    with: [.empty],
                    isCanLoading: isCanLoading,
                    totalCount: totalCount,
                    filterItem: filterItem
                )
            } else {
                let items: [ProductCellType] = eventProductResult.map { .item($0) }
                presenter.presentProducts(
                    with: items,
                    isCanLoading: isCanLoading,
                    totalCount: totalCount,
                    filterItem: filterItem
                )
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
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func popViewController() {
        listener?.popProductSearch()
    }
    
    func search(with keyword: String?) {
        self.keyword = keyword
        self.pageNumber = 0
        self.filterItem = .init(name: "최신순", code: 0, isSelected: true)
        
        if let keyword,
           !keyword.isEmpty {
            dependency.productAPIService.requestSearch(
                pageNumber: pageNumber,
                pageSize: pageSize,
                name: keyword,
                sortedCode: filterItem.code
            )
            .sink { [weak self] response in
                if let productPage = response.value {
                    let isLastPage = self?.pageNumber == (productPage.totalPages - 1)
                    let contentIsEmpty = productPage.content.count == 0
                    self?.isCanLoading = !isLastPage && !contentIsEmpty
                    self?.totalCount = productPage.totalElements
                    self?.eventProductResult = productPage.content
                }
            }
            .store(in: &cancellable)
        } else {
            presenter.presentProducts(
                with: [.empty],
                isCanLoading: false,
                totalCount: 0,
                filterItem: filterItem
            )
        }
    }
    
    func loadMoreItems() {
        if let keyword,
           !keyword.isEmpty {
            pageNumber += 1
            dependency.productAPIService.requestSearch(
                pageNumber: pageNumber,
                pageSize: pageSize,
                name: keyword,
                sortedCode: filterItem.code
            )
            .sink { [weak self] response in
                if let productPage = response.value {
                    var currentProducts = self?.eventProductResult ?? []
                    let isLastPage = self?.pageNumber == (productPage.totalPages - 1)
                    let contentIsEmpty = productPage.content.count == 0
                    self?.isCanLoading = !isLastPage && !contentIsEmpty
                    self?.totalCount = productPage.totalElements
                    currentProducts += productPage.content
                    self?.eventProductResult = currentProducts
                }
            }
            .store(in: &cancellable)
        } else {
            presenter.presentProducts(
                with: [.empty],
                isCanLoading: false,
                totalCount: 0,
                filterItem: filterItem
            )
        }
    }
    
    private func requestSort(filterItem: FilterItemEntity) {
        self.pageNumber = 0
        self.filterItem = filterItem
        
        if let keyword,
           !keyword.isEmpty {
            dependency.productAPIService.requestSearch(
                pageNumber: pageNumber,
                pageSize: pageSize,
                name: keyword,
                sortedCode: filterItem.code
            )
            .sink { [weak self] response in
                if let productPage = response.value {
                    let isLastPage = self?.pageNumber == (productPage.totalPages - 1)
                    let contentIsEmpty = productPage.content.count == 0
                    self?.isCanLoading = !isLastPage && !contentIsEmpty
                    self?.totalCount = productPage.totalElements
                    self?.eventProductResult = productPage.content
                }
            }
            .store(in: &cancellable)
        } else {
            presenter.presentProducts(
                with: [.empty],
                isCanLoading: false,
                totalCount: 0,
                filterItem: filterItem
            )
        }
    }
    
    func setSort(sort: FilterItemEntity) {
    }
    
    func didTapSortButton(filterItem: FilterItemEntity) {
        var filterItems: [FilterItemEntity] = [
            .init(name: "최신순", code: 1),
            .init(name: "낮은 가격 순", code: 2),
            .init(name: "높은 가격 순", code: 3)
        ]
        if let index = filterItems.firstIndex(where: { item in
            return item.code == filterItem.code
        }) {
            let targetItem = filterItems[index]
            filterItems[index] = .init(
                name: targetItem.name,
                code: targetItem.code,
                isSelected: true
            )
        }
        
        let filterEntity: FilterEntity = .init(
            filterType: .sort,
            defaultText: "정렬 선택",
            filterItem: filterItems
        )
        router?.attachProductFilter(of: filterEntity)
    }
    
    func productFilterDidTapCloseButton() {
        router?.detachProductFilter()
    }
    
    func applyFilterItems(_ items: [FilterItemEntity]) {
    }
    
    func applySortFilter(type: FilterItemEntity) {
        requestSort(filterItem: type)
        router?.detachProductFilter()
    }
}
