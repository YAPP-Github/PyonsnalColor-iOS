//
//  PersonalViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/15.
//

import UIKit
import SnapKit

protocol ScrollDelegate: AnyObject {
    func didScroll(scrollView: UIScrollView)
    func willBeginDragging(scrollView: UIScrollView)
    func didEndDragging(scrollView: UIScrollView)
}

// 임의의 모델 타입
struct ItemCard: Hashable {
    var uuid = UUID()
    var imageUrl: UIImage?
    var itemName: String
    var convenientStoreTagImage: UIImage?
    var eventTagImage: UIImage?
}

final class EventHomeTabViewController: UIViewController {
    
    enum SectionType: Hashable {
        case event
        case item
    }
    
    enum ItemType: Hashable {
        case event(data: String)
        case item(data: ItemCard)
    }
    
    enum Size {
        static let topMargin: CGFloat = 20
    }
    
    weak var scrollDelegate: ScrollDelegate?
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createLayout())
        return collectionView
    }()
    
    // MARK: - Private property
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, ItemType>?
    private var itemCards: [ItemCard] = []
    private var headerTitle: [String] = []
    private var eventUrls: [String] = []
    private let refreshControl = UIRefreshControl()
    private let dummyImage = UIImage(systemName: "note")
    private var lastContentOffSetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDummyData()
        configureUI()
        configureLayout()
        configureCollectionView()
        configureDatasource()
        configureHeaderView()
        makeSnapshot()
    }
    
    // MARK: - Private Method
    private func configureDummyData() {
        itemCards = [
            ItemCard(imageUrl: dummyImage,
                     itemName: "산리오)햄치즈에그모닝머핀ddd",
                     convenientStoreTagImage: dummyImage,
                     eventTagImage: dummyImage),
            ItemCard(imageUrl: dummyImage,
                     itemName: "나가사끼 짬뽕",
                     convenientStoreTagImage: dummyImage,
                     eventTagImage: dummyImage),
            ItemCard(imageUrl: dummyImage,
                     itemName: "나가사끼 짬뽕",
                     convenientStoreTagImage: dummyImage,
                     eventTagImage: dummyImage),
            ItemCard(imageUrl: dummyImage,
                     itemName: "나가사끼 짬뽕",
                     convenientStoreTagImage: dummyImage,
                     eventTagImage: dummyImage),
            ItemCard(imageUrl: dummyImage,
                     itemName: "나가사끼 짬뽕",
                     convenientStoreTagImage: dummyImage,
                     eventTagImage: dummyImage),
            ItemCard(imageUrl: dummyImage,
                     itemName: "나가사끼 짬뽕",
                     convenientStoreTagImage: dummyImage,
                     eventTagImage: dummyImage)
        ]
        eventUrls = ["test"]
        headerTitle = ["이달의 이벤트 💌", "행사 상품 모아보기 👀"]
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else {
                return nil
            }
            
            let layout = EventHomeSectionLayout()
            return layout.section(at: sectionIdentifier)
        }
    }
    
    private func configureUI() {
        //TO DO : fix color
        view.backgroundColor = .gray
        collectionView.backgroundColor = .gray
        setNavigationView()
    }
    
    private func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setNavigationView() {
        title = "이벤트"
        tabBarItem = UITabBarItem(title: "이벤트",
                                  image: UIImage(systemName: "square.and.arrow.up"),
                                  selectedImage: UIImage(systemName: "square.and.arrow.up.fill"))
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: Size.topMargin,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        registerCollectionViewCells()
        setRefreshControl()
    }
    
    
    private func registerCollectionViewCells() {
        collectionView.register(ItemHeaderTitleView.self,
                                forSupplementaryViewOfKind: ItemHeaderTitleView.className,
                                withReuseIdentifier: ItemHeaderTitleView.className)
        collectionView.register(EventBannerCell.self,
                                forCellWithReuseIdentifier: EventBannerCell.className)
        collectionView.register(ProductCell.self,
                                forCellWithReuseIdentifier: ProductCell.className)
    }
    
    private func setRefreshControl() {
        refreshControl.addTarget(self,
                                 action: #selector(pullToRefresh),
                                 for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func pullToRefresh() {
        collectionView.refreshControl?.beginRefreshing()
        
        //get data from api
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.makeSnapshot()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func configureDatasource() {
        dataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .item(let item):
                let cell: ProductCell? = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.className,
                                                                            for: indexPath) as? ProductCell
                return cell ?? UICollectionViewCell()
            case .event(let item):
                let cell: EventBannerCell? = collectionView.dequeueReusableCell(withReuseIdentifier: EventBannerCell.className, for: indexPath) as? EventBannerCell
                cell?.update(self.eventUrls)
                return cell ?? UICollectionViewCell()
            }
        }
    }
    
    private func configureHeaderView() {
        dataSource?.supplementaryViewProvider = makeSupplementaryView
    }
    
    private func makeSupplementaryView(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        switch kind {
        case ItemHeaderTitleView.className:
            let itemHeaderTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: kind,
                                                                                      for: indexPath) as? ItemHeaderTitleView
            let sectionText = headerTitle[indexPath.section]
            let isEventLayout = indexPath.section == 0
            itemHeaderTitleView?.update(isEventLayout: isEventLayout,
                                        title: sectionText)
            return itemHeaderTitleView
        default:
            return nil
        }
    }
    
    private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
        //append event section
        if !eventUrls.isEmpty {
            snapshot.appendSections([.event])
            let eventUrls = eventUrls.map { eventUrl in
                return ItemType.event(data: eventUrl)
            }
            snapshot.appendItems(eventUrls, toSection: .event)
        }
        
        //append item section
        if !itemCards.isEmpty {
            snapshot.appendSections([.item])
            let itemCards = itemCards.map { itemCard in
                return ItemType.item(data: itemCard)
            }
            snapshot.appendItems(itemCards, toSection: .item)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


extension EventHomeTabViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.didScroll(scrollView: scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegate?.willBeginDragging(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.didEndDragging(scrollView: scrollView)
    }
}
