//
//  ProductCurationViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/22.
//

import UIKit
import SnapKit

protocol CurationDelegate: AnyObject {
    func curationWillAppear()
}

final class ProductCurationViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    enum Section: Hashable {
        case image
        case curation(data: CurationEntity)
        case eventImage(data: EventImageEntity)
        case adMob
    }
    
    enum Item: Hashable {
        case image(data: UIImage?)
        case curation(data: ProductDetailEntity)
        case eventImage(data: [String])
        case adMob
    }
    
    enum Constant {
        static let firstCurationIndex: Int = 1
    }
    
    // MARK: Property
    weak var delegate: ProductListDelegate?
    weak var curationDelegate: CurationDelegate?
    
    private var dataSource: DataSource?
    lazy var adMobManager = AdMobManager(
        fromViewController: nil,
        loadAdType: [.native],
        adUnitIdType: .curationMiddleAd
    )
    
    lazy var curationCollectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        curationDelegate?.curationWillAppear()
    }
    
    // MARK: - Private Method
    private func configureCollectionView() {
        curationCollectionView.delegate = self
        configureLayout()
        registerCells()
        configureDataSource()
        configureSupplementaryView()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) in
            guard let section = self.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            return CurationSectionLayout().createSection(at: section)
        }
        
        return layout
    }
    
    private func configureLayout() {
        view.addSubview(curationCollectionView)
        
        curationCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func registerCells() {
        curationCollectionView.register(CurationImageCell.self)
        curationCollectionView.register(ProductCell.self)
        curationCollectionView.register(EventImageCell.self)
        curationCollectionView.register(CurationAdCell.self)
        curationCollectionView.registerHeaderView(CurationHeaderView.self)
        curationCollectionView.registerFooterView(CurationFooterView.self)
        curationCollectionView.registerHeaderView(EventBannerHeaderView.self)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: curationCollectionView
        ) { collectionView, indexPath, item in
            switch item {
            case .image:
                let cell: CurationImageCell = collectionView.dequeueReusableCell(for: indexPath)
                return cell
            case let .curation(data):
                let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.updateCell(with: data)
                cell.delegate = self
                return cell
            case let .eventImage(data):
                let cell: EventImageCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.update(data)
                cell.delegate = self
            case .adMob:
                let cell: CurationAdCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setAdMobManagerIfNeeded(adMobManager: self.adMobManager)
                return cell
            }
        }
    }
    
    private func configureSupplementaryView() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let section = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                    return nil
                }
                
                if case let .curation(curation) = section {
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: CurationHeaderView.identifier,
                        for: indexPath
                    ) as? CurationHeaderView else {
                        return nil
                    }
                    
                    headerView.configureHeaderView(with: curation)
                    return headerView
                } else if case let .eventImage(eventImage) = section {
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: EventBannerHeaderView.identifier,
                        for: indexPath
                    ) as? EventBannerHeaderView else {
                        return nil
                    }
                    
                    headerView.configureHeaderView(title: eventImage.title)
                    return headerView
                } else {
                    return nil
                }
            } else if kind == UICollectionView.elementKindSectionFooter {
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: String(describing: CurationFooterView.self),
                    for: indexPath
                ) as? CurationFooterView else {
                    return nil
                }
                
                if let numberOfSection = self.dataSource?.numberOfSections(in: collectionView) {
                    if indexPath.section == numberOfSection - 1 {
                        footerView.isHidden = true
                    }
                }

                return footerView
            } else {
                return nil
            }
        }
    }
    
    // TODO: 기존 curation 메서드 삭제
    func applySnapshot(with products: [CurationEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        snapshot.appendSections([.image])
        snapshot.appendItems([.image(data: UIImage(systemName: ""))])

        products.forEach { curation in
            snapshot.appendSections([.curation(data: curation)])
            curation.products.forEach { product in
                snapshot.appendItems([.curation(data: product)])
            }
        }
        
        if let lastSection = snapshot.sectionIdentifiers.last {
            snapshot.insertSections([.adMob], beforeSection: lastSection)
            snapshot.appendItems([.adMob], toSection: .adMob)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func applySnapshot(with items: [HomeBannerEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.image])
        snapshot.appendItems([.image(data: UIImage(systemName: ""))])
        
        items.forEach { item in
            item.value.forEach { value in
                if let curation = value.curationProducts {
                    snapshot.appendSections([.curation(data: curation)])
                    curation.products.forEach { product in
                        snapshot.appendItems([.curation(data: product)])
                    }
                } else if let eventImages = value.eventImages {
                    snapshot.appendSections([.eventImage(data: eventImages)])
                    // TODO: URL.first 삭제 예정 (중복으로 인한 크래시 방지)
                    snapshot.appendItems([.eventImage(data: [eventImages.imageURL.first ?? ""])])
                    
                    let curationSection = snapshot.sectionIdentifiers[Constant.firstCurationIndex]
                    snapshot.moveSection(
                        .eventImage(data: eventImages),
                        afterSection: curationSection
                    )
                }
            }
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - Method
    func scrollCollectionViewToTop() {
        curationCollectionView.setContentOffset(.init(x: 0, y: 0), animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension ProductCurationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource?.itemIdentifier(for: indexPath)
        
        if case let .curation(product) = item {
            logging(.itemClick, parameter: [
                .productName: product.name
            ])
            delegate?.didSelect(with: product)
        }
    }
}

// MARK: - ProductCellDelegate
extension ProductCurationViewController: ProductCellDelegate {
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction) {
        switch action {
        case .add:
            logging(.like, parameter: [
                .productName: product.name
            ])
        case .delete:
            logging(.unlike, parameter: [
                .productName: product.name
            ])
        }
        delegate?.didTapFavoriteButton(product: product, action: action)
    }
}

// MARK: - EventImageCellDelegate
extension ProductCurationViewController: EventImageCellDelegate {
    func didTapEventImageCell(with imageURL: String) {
        // TODO: 이벤트 상세페이지 이동 로직 작성 예정
    }
}
