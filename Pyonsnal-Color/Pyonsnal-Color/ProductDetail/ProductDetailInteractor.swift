//
//  ProductDetailInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs
import Combine

protocol ProductDetailRouting: ViewableRouting {
}

protocol ProductDetailPresentable: Presentable {
    var listener: ProductDetailPresentableListener? { get set }
    func setFavoriteState(isSelected: Bool)
    func reloadCollectionView(with sectionModels: [ProductDetailSectionModel])
}

protocol ProductDetailListener: AnyObject {
    func popProductDetail()
}

final class ProductDetailInteractor: PresentableInteractor<ProductDetailPresentable>,
                                     ProductDetailInteractable,
                                     ProductDetailPresentableListener {

    weak var router: ProductDetailRouting?
    weak var listener: ProductDetailListener?

    // MARK: - Private Property
    private let favoriteAPIService: FavoriteAPIService
    private let dependency: ProductDetailDependency
    private let selectedProduct: ProductDetailEntity
    private var productDetail: ProductDetailEntity?
    private var cancellable = Set<AnyCancellable>()
    
    // in constructor.
    init(
        presenter: ProductDetailPresentable,
        favoriteAPIService: FavoriteAPIService,
        dependency: ProductDetailDependency,
        product: ProductDetailEntity
    ) {
        self.dependency = dependency
        self.favoriteAPIService = favoriteAPIService
        self.selectedProduct = product
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        requestProductDetail()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func popViewController() {
        listener?.popProductDetail()
    }
    
    func addFavorite() {
        guard let productDetail else { return }
        favoriteAPIService.addFavorite(
            productId: productDetail.id,
            productType: productDetail.productType
            ).sink { [weak self] response in
                if response.error != nil {
                    self?.presenter.setFavoriteState(isSelected: true)
                } else {
                   // TODO: error handling
                }
            }.store(in: &cancellable)
        }
        
        func deleteFavorite() {
            guard let productDetail else { return }
            favoriteAPIService.deleteFavorite(
                productId: productDetail.id,
                productType: productDetail.productType
            ).sink { [weak self] response in
                if response.error != nil {
                    self?.presenter.setFavoriteState(isSelected: false)
                } else {
                    // TODO: error handling
                }
            }.store(in: &cancellable)
        }
    
    func refresh() {
        requestProductDetail()
    }
        
    func reloadData(with productDetail: ProductDetailEntity) {
        self.productDetail = productDetail
        
        let reviews = productDetail.reviews
        var sectionModels: [ProductDetailSectionModel] = []
        sectionModels.append(
            .init(
                section: ProductDetailSection.image,
                items: [
                    ProductDetailSectionItem.image(imageURL: productDetail.imageURL)
                ]
            )
        )
        sectionModels.append(
            .init(
                section: ProductDetailSection.information,
                items: [
                    ProductDetailSectionItem.information(product: productDetail)
                ]
            )
        )
        if let avgScore = productDetail.avgScore {
            sectionModels.append(
                .init(
                    section: ProductDetailSection.reviewWrite,
                    items: [
                        ProductDetailSectionItem.reviewWrite(
                            score: avgScore,
                            reviewsCount: reviews.count
                        )
                    ]
                )
            )
        }
        sectionModels.append(
            .init(
                section: ProductDetailSection.review,
                items: reviews.map { ProductDetailSectionItem.review(productReview: $0) }
            )
        )
        presenter.reloadCollectionView(with: sectionModels)
    }
    
    func writeButtonDidTap() {
        
    }
    
    func sortButtonDidTap() {
//
//        router?.
    }
    
    func reviewLikeButtonDidTap(review: ReviewEntity) {
        requestReviewLike(reviewID: "review.id")
    }
    
    func reviewHateButtonDidTap(review: ReviewEntity) {
        requestReviewHate(reviewID: "review.id")
    }
    
    private func requestProductDetail() {
        switch selectedProduct.productType {
        case .pb:
            dependency.productAPIService.requestBrandProductDetail(id: selectedProduct.id)
                .sink { [weak self] response in
                    if let product = response.value {
                        self?.reloadData(with: product)
                    }
                }
                .store(in: &cancellable)
        case .event:
            dependency.productAPIService.requestEventProductDetail(id: selectedProduct.id)
                .sink { [weak self] response in
                    if let product = response.value {
                        self?.reloadData(with: product)
                    }
                }
                .store(in: &cancellable)
        default: return
        }
    }
    
    private func requestReviewLike(reviewID: String) {
        switch selectedProduct.productType {
        case .pb:
            dependency.productAPIService.requestBrandProductReviewLike(
                productID: selectedProduct.id,
                reviewID: "review.id"
            )
            .sink { [weak self] _ in
            }
            .store(in: &cancellable)
        case .event:
            dependency.productAPIService.requestEventProductReviewLike(
                productID: selectedProduct.id,
                reviewID: "review.id"
            )
            .sink { [weak self] _ in
            }
            .store(in: &cancellable)
        default: return
        }
    }
    
    private func requestReviewHate(reviewID: String) {
        switch selectedProduct.productType {
        case .pb:
            dependency.productAPIService.requestBrandProductReviewHate(
                productID: selectedProduct.id,
                reviewID: "review.id"
            )
            .sink { [weak self] _ in
            }
            .store(in: &cancellable)
        case .event:
            dependency.productAPIService.requestEventProductReviewHate(
                productID: selectedProduct.id,
                reviewID: "review.id"
            )
            .sink { [weak self] _ in
            }
            .store(in: &cancellable)
        default: return
        }
    }
}
