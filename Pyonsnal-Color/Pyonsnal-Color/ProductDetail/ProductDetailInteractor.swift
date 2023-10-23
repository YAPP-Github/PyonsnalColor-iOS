//
//  ProductDetailInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import ModernRIBs
import Combine

protocol ProductDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachStarRatingReview(with productDetail: ProductDetailEntity)
    func detachStarRatingReview()
}

protocol ProductDetailPresentable: Presentable {
    var listener: ProductDetailPresentableListener? { get set }
    func setFavoriteState(isSelected: Bool)
    func reloadCollectionView(with sectionModels: [ProductDetailSectionModel])
    func updateHeaderImage(storeIcon: ImageAssetKind.StoreIcon)
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
    private(set) var product: ProductDetailEntity
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
        self.product = product
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        requestProductDetail()
        presenter.updateHeaderImage(storeIcon: product.storeType.storeIcon)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func popViewController() {
        listener?.popProductDetail()
    }
    
    func addFavorite() {
        favoriteAPIService.addFavorite(
            productId: product.id,
            productType: product.productType
            ).sink { [weak self] response in
                if response.error != nil {
                    self?.presenter.setFavoriteState(isSelected: true)
                } else {
                   // TODO: error handling
                }
            }.store(in: &cancellable)
        }
        
        func deleteFavorite() {
            favoriteAPIService.deleteFavorite(
                productId: product.id,
                productType: product.productType
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
        self.product = productDetail
        
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
                            reviewsCount: productDetail.reviews.count
                        )
                    ]
                )
            )
        }
//        let dummyReviews = [
//            ReviewEntity(
//                reviewId: "ffwae",
//                taste: .good,
//                quality: .bad,
//                valueForMoney: .normal,
//                score: 4,
//                contents: "쪼아요\n부우웅...위이잉...\n치...킨.도미노...피짜",
//                image: .init(string: "https://products.shureweb.eu/shure_product_db/product_images/files/35f/9c0/aa-/setcard/7b97831f8f26a63b8164cf8fe84fd4e9.jpeg"),
//                writerId: 100,
//                writerName: "류이치",
//                createdTime: "",
//                updatedTime: "",
//                likeCount: ReviewLikeCountEntity(writerIds: [14], likeCount: 10),
//                hateCount: ReviewHateCountEntity(writerIds: [], hateCount: 32)
//            ),
//            ReviewEntity(
//                reviewId: "fefew",
//                taste: .good,
//                quality: .bad,
//                valueForMoney: .normal,
//                score: 4,
//                contents: "쪼아요fejwiofjeawiojfeioajfoieawjfjioaejfiaowjfeoiwajeiofjeoiwjfioejwaiojfeaiwoejf",
//                image: .init(string: "https://products.shureweb.eu/shure_product_db/product_images/files/35f/9c0/aa-/setcard/7b97831f8f26a63b8164cf8fe84fd4e9.jpeg"),
//                writerId: 100,
//                writerName: "류이치",
//                createdTime: "",
//                updatedTime: "",
//                likeCount: ReviewLikeCountEntity(writerIds: [], likeCount: 333),
//                hateCount: ReviewHateCountEntity(writerIds: [14], hateCount: 32)
//            ),
//            ReviewEntity(
//                reviewId: "fgeawe",
//                taste: .good,
//                quality: .bad,
//                valueForMoney: .normal,
//                score: 4,
//                contents: "쪼아요\nkkkkkhhuijoijiojoijoijiojoijojioiojij\njoijiojioj\nfaewawefa\nfewaiofjwa\nfjewiao",
//                image: .init(string: "https://products.shureweb.eu/shure_product_db/product_images/files/35f/9c0/aa-/setcard/7b97831f8f26a63b8164cf8fe84fd4e9.jpeg"),
//                writerId: 100,
//                writerName: "류이치",
//                createdTime: "",
//                updatedTime: "",
//                likeCount: ReviewLikeCountEntity(writerIds: [], likeCount: 0),
//                hateCount: ReviewHateCountEntity(writerIds: [], hateCount: 0)
//            )
//        ]
        sectionModels.append(
            .init(
                section: ProductDetailSection.review,
                items: productDetail.reviews.map { ProductDetailSectionItem.review(productReview: $0) }
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
        requestReviewLike(reviewID: review.reviewId)
    }
    
    func reviewHateButtonDidTap(review: ReviewEntity) {
        requestReviewHate(reviewID: review.reviewId)
    }
    
    private func requestProductDetail() {
        switch product.productType {
        case .pb:
            dependency.productAPIService.requestBrandProductDetail(id: product.id)
                .sink { [weak self] response in
                    if let product = response.value {
                        self?.reloadData(with: product)
                    }
                }
                .store(in: &cancellable)
        case .event:
            dependency.productAPIService.requestEventProductDetail(id: product.id)
                .sink { [weak self] response in
                    if let product = response.value {
                        self?.reloadData(with: product)
                    }
                }
                .store(in: &cancellable)
        }
    }
    
    private func requestReviewLike(reviewID: String) {
        switch product.productType {
        case .pb:
            dependency.productAPIService.requestBrandProductReviewLike(
                productID: product.id,
                reviewID: reviewID
            )
            .sink { [weak self] _ in
                self?.updateReviewLike(reviewID: reviewID)
            }
            .store(in: &cancellable)
        case .event:
            dependency.productAPIService.requestEventProductReviewLike(
                productID: product.id,
                reviewID: reviewID
            )
            .sink { [weak self] _ in
                self?.updateReviewLike(reviewID: reviewID)
            }
            .store(in: &cancellable)
        }
    }
    
    private func requestReviewHate(reviewID: String) {
        switch product.productType {
        case .pb:
            dependency.productAPIService.requestBrandProductReviewHate(
                productID: product.id,
                reviewID: reviewID
            )
            .sink { [weak self] _ in
                self?.updateReviewHate(reviewID: reviewID)
            }
            .store(in: &cancellable)
        case .event:
            dependency.productAPIService.requestEventProductReviewHate(
                productID: product.id,
                reviewID: reviewID
            )
            .sink { [weak self] _ in
                self?.updateReviewHate(reviewID: reviewID)
            }
            .store(in: &cancellable)
        }
    }
    
    func attachStarRatingReview() {
        guard let productDetail else { return }
        
        router?.attachStarRatingReview(with: productDetail)
    }
    
    func detachStarRatingReview() {
        router?.detachStarRatingReview()
    }
    
    private func updateReviewLike(reviewID: String) {
        guard let memberID = UserInfoService.shared.memberID else {
            return
        }
        
        guard let reviewIndex = product.reviews.firstIndex(
            where: { $0.reviewId == reviewID }
        ) else {
            return
        }
        let review = product.reviews[reviewIndex]
        var writerIds = review.likeCount.writerIds
        writerIds.append(memberID)
        let updatedReview = review.update(
            likeCount: .init(writerIds: writerIds, likeCount: review.likeCount.likeCount + 1)
        )
        
        var updatedReviews = product.reviews
        updatedReviews[reviewIndex] = updatedReview
        let updatedProductDetail = product.updateReviews(reviews: updatedReviews)
        reloadData(with: updatedProductDetail)
    }
    
    private func updateReviewHate(reviewID: String) {
        guard let memberID = UserInfoService.shared.memberID else {
            return
        }
        
        guard let reviewIndex = product.reviews.firstIndex(
            where: { $0.reviewId == reviewID }
        ) else {
            return
        }
        let review = product.reviews[reviewIndex]
        var writerIds = review.hateCount.writerIds
        writerIds.append(memberID)
        let updatedReview = review.update(
            hateCount: .init(writerIds: writerIds, hateCount: review.hateCount.hateCount + 1)
        )
        
        var updatedReviews = product.reviews
        updatedReviews[reviewIndex] = updatedReview
        let updatedProductDetail = product.updateReviews(reviews: updatedReviews)
        reloadData(with: updatedProductDetail)
    }
}
