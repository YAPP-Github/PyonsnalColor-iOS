//
//  ProductDetailViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/23.
//

import UIKit
import Combine
import ModernRIBs

protocol ProductDetailPresentableListener: AnyObject {
    func popViewController()
    func addFavorite()
    func deleteFavorite()
    func refresh()
    func reloadData(with productDetail: ProductDetailEntity)
    func writeButtonDidTap()
    func sortButtonDidTap()
    func reviewLikeButtonDidTap(review: ReviewEntity)
    func reviewHateButtonDidTap(review: ReviewEntity)
}

final class ProductDetailViewController:
    UIViewController,
    ProductDetailPresentable,
    ProductDetailViewControllable
{
    // MARK: - Declaration
    enum Text {
        static let updateLabelTextPrefix: String = "업데이트"
    }
    
    // MARK: - Interface
    weak var listener: ProductDetailPresentableListener?
    var productDetail: ProductDetailEntity? {
        didSet { updateUI() }
    }
    
    // MARK: - Private Method
    private let viewHolder: ViewHolder = .init()
    private var cancellable = Set<AnyCancellable>()
    private var sections: [ProductDetailSectionModel]? {
        didSet {
            OperationQueue.main.addOperation {
                self.viewHolder.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        
        configureAction()
        bindActions()
    }
    
    // MARK: - Public Method
    func setFavoriteState(isSelected: Bool) {
        viewHolder.backNavigationView.setFavoriteButtonSelected(isSelected: isSelected)
        viewHolder.collectionView.dataSource = self
        viewHolder.collectionView.delegate = self
    }
    
    // MARK: - Private Method
    private func updateUI() {
        view.backgroundColor = .white
        
        guard var productDetail else { return }
        let dummyProductDetail: ProductDetailEntity = .init(
            id: productDetail.id,
            storeType: productDetail.storeType,
            imageURL: productDetail.imageURL,
            name: productDetail.name,
            price: productDetail.price,
            eventType: productDetail.eventType,
            productType: productDetail.productType,
            updatedTime: productDetail.updatedTime,
            description: productDetail.description,
            isNew: productDetail.isNew,
            viewCount: productDetail.viewCount,
            category: productDetail.category,
            isFavorite: productDetail.isFavorite,
            originPrice: productDetail.originPrice,
            giftImageURL: .init(string: "https://upload.wikimedia.org/wikipedia/ko/a/a6/Pok%C3%A9mon_Pikachu_art.png"),
            giftTitle: "Hello",
            giftPrice: "2,000",
            isEventExpired: false,
            reviews: [
                ReviewEntity(
                    taste: .good,
                    quality: .bad,
                    valueForMoney: .normal,
                    score: 4,
                    contents: "쪼아요\n부우웅...위이잉...\n치...킨.도미노...피짜",
                    image: .init(string: "https://products.shureweb.eu/shure_product_db/product_images/files/35f/9c0/aa-/setcard/7b97831f8f26a63b8164cf8fe84fd4e9.jpeg"),
                    writerId: 100,
                    writerName: "류이치",
                    createdTime: "",
                    updatedTime: "",
                    likeCount: 10,
                    hateCount: 32
                ),
                ReviewEntity(
                    taste: .good,
                    quality: .bad,
                    valueForMoney: .normal,
                    score: 4,
                    contents: "쪼아요fejwiofjeawiojfeioajfoieawjfjioaejfiaowjfeoiwajeiofjeoiwjfioejwaiojfeaiwoejf",
                    image: .init(string: "https://products.shureweb.eu/shure_product_db/product_images/files/35f/9c0/aa-/setcard/7b97831f8f26a63b8164cf8fe84fd4e9.jpeg"),
                    writerId: 100,
                    writerName: "류이치",
                    createdTime: "",
                    updatedTime: "",
                    likeCount: 333,
                    hateCount: 23
                ),
                ReviewEntity(
                    taste: .good,
                    quality: .bad,
                    valueForMoney: .normal,
                    score: 4,
                    contents: "쪼아요\nkkkkkhhuijoijiojoijoijiojoijojioiojij\njoijiojioj\nfaewawefa\nfewaiofjwa\nfjewiao",
                    image: .init(string: "https://products.shureweb.eu/shure_product_db/product_images/files/35f/9c0/aa-/setcard/7b97831f8f26a63b8164cf8fe84fd4e9.jpeg"),
                    writerId: 100,
                    writerName: "류이치",
                    createdTime: "",
                    updatedTime: "",
                    likeCount: 0,
                    hateCount: 0
                ),
                ReviewEntity(
                    taste: .good,
                    quality: .bad,
                    valueForMoney: .normal,
                    score: 4,
                    contents: "쪼아요",
                    image: .init(string: "https://products.shureweb.eu/shure_product_db/product_images/files/35f/9c0/aa-/setcard/7b97831f8f26a63b8164cf8fe84fd4e9.jpeg"),
                    writerId: 100,
                    writerName: "류이치",
                    createdTime: "",
                    updatedTime: "",
                    likeCount: 0,
                    hateCount: 0
                )
            ],
            avgScore: 4.5
        )
        listener?.reloadData(with: dummyProductDetail)
    }
    
    private func configureAction() {
        viewHolder.backNavigationView.delegate = self
    }
    
    private func bindActions() {
        viewHolder.backNavigationView.favoriteButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self else { return }
                let action: FavoriteButtonAction = viewHolder.backNavigationView.getFavoriteButtonSelected() ? .delete : .add
                if action == .add {
                    listener?.addFavorite()
                } else if action == .delete {
                    listener?.deleteFavorite()
                }
            }.store(in: &cancellable)
        
        viewHolder.collectionView.refreshControl?.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
    }
    
    @objc private func refreshControlAction() {
        listener?.refresh()
    }

    func reloadCollectionView(with sectionModels: [ProductDetailSectionModel]) {
        viewHolder.collectionView.refreshControl?.endRefreshing()  
        self.sections = sectionModels
    }
}

extension ProductDetailViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.popViewController()
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections {
            return sections.count
        }
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if let sections {
            return sections[section].items.count
        }
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let sections else {
            return UICollectionViewCell()
        }
        let section = sections[indexPath.section]
        switch section.items[indexPath.item] {
        case let .image(imageURL):
            let imageCell: ProductDetailImageCell = collectionView.dequeueReusableCell(
                for: indexPath
            )
            imageCell.payload = .init(imageURL: imageURL)
            return imageCell
        case let .information(entity):
            let informationCell: ProductDetailInformationCell = collectionView.dequeueReusableCell(
                for: indexPath
            )
            informationCell.payload = .init(productDetail: entity)
            return informationCell
        case let .reviewWrite(score, reviewsCount):
            let reviewWriteCell: ProductDetailReviewWriteCell = collectionView.dequeueReusableCell(
                for: indexPath
            )
            reviewWriteCell.payload = .init(score: score, reviewsCount: reviewsCount)
            reviewWriteCell.delegate = self
            return reviewWriteCell
        case let .review(entity):
            let reviewCell: ProductDetailReviewCell = collectionView.dequeueReusableCell(
                for: indexPath
            )
            reviewCell.payload = .init(review: entity)
            reviewCell.delegate = self
            return reviewCell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LineFooter.identifier,
                for: indexPath
            )
            return footer
        } else {
            return UICollectionReusableView()
        }
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let sections else {
            return .zero
        }
        let section = sections[indexPath.section]
        let screenWidth = collectionView.bounds.width
        switch section.items[indexPath.item] {
        case .image:
            return .init(width: screenWidth, height: 320)
        case let .information(entity):
            let width = collectionView.bounds.size.width
            let estimateHeight: CGFloat = 400
            let cell = ProductDetailInformationCell()
            cell.payload = .init(productDetail: entity)
            cell.frame = .init(
                origin: .zero,
                size: .init(width: width, height: estimateHeight)
            )
            cell.layoutIfNeeded()
            let estimateSize = cell.systemLayoutSizeFitting(
                .init(width: width, height: estimateHeight)
            )
            return .init(width: screenWidth, height: estimateSize.height)
        case .reviewWrite:
            return .init(width: screenWidth, height: 300)
        case let .review(entity):
            let width = collectionView.bounds.size.width
            let estimateHeight: CGFloat = 1000
            let cell = ProductDetailReviewCell()
            cell.frame = .init(
                origin: .zero,
                size: .init(width: width, height: estimateHeight)
            )
            cell.payload = .init(review: entity)
            cell.layoutIfNeeded()
            let estimateSize = cell.systemLayoutSizeFitting(
                .init(width: width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow
            )
            return estimateSize
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        let width = collectionView.bounds.width
        guard let sections else {
            return .zero
        }
        let section = sections[section]
        switch section.section {
        case .image:
            return .init(width: width, height: 12)
        case .information:
            return .init(width: width, height: 12)
        default:
            return .zero
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .zero
    }

}

extension ProductDetailViewController: ProductDetailReviewWriteCellDelegate {
    func writeButtonDidTap() {
        print("Write")
    }
    
    func sortButtonDidTap() {
        print("Sort")
    }
}

extension ProductDetailViewController: ProductDetailReviewCellDelegate {
    func goodButtonDidTap(review: ReviewEntity) {
        listener?.reviewLikeButtonDidTap(review: review)
    }
    
    func badButtonDidTap(review: ReviewEntity) {
        listener?.reviewHateButtonDidTap(review: review)
    }
}
