//
//  ProductHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import UIKit

protocol ProductHomePresentableListener: AnyObject {
    func didChangeStore(to store: ConvenienceStore)
    func didTapSearchButton()
    func didTapNotificationButton()
    func didScrollToNextPage(store: ConvenienceStore)
    func didSelect(with brandProduct: ProductConvertable)
}

final class ProductHomeViewController:
    UIViewController,
    ProductHomePresentable,
    ProductHomeViewControllable {

    //MARK: - Interface
    weak var listener: ProductHomePresentableListener?
    
    //MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private let convenienceStores: [String] = CommonConstants.convenienceStore
    private let initialIndex: Int = 0
    private var innerScrollLastOffsetY: CGFloat = 0
    private var isPaging: Bool = false
    private var currentPage: Int = 0
    
    //MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        setupStoreCollectionView()
        setupProductCollectionView()
        configureNotificationButton()
    }
    
    //MARK: - Private Method
    private func setupViews() {
        let customFont: UIFont = .label2
        
        tabBarItem.setTitleTextAttributes([.font: customFont], for: .normal)
        tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(named: "home"),
            selectedImage: UIImage(named: "home.selected")
        )
        
        view.backgroundColor = .white
        viewHolder.containerScrollView.delegate = self
    }
    
    private func setupStoreCollectionView() {
        viewHolder.convenienceStoreCollectionView.dataSource = self
        viewHolder.convenienceStoreCollectionView.delegate = self
    }
    
    private func setupProductCollectionView() {
        viewHolder.productHomePageViewController.pagingDelegate = self
        viewHolder.productHomePageViewController.productListViewControllers.forEach {
            $0.productCollectionView.delegate = self
        }
        viewHolder.productHomePageViewController.productListViewControllers.forEach {
            $0.delegate = self
        }
    }
    
    private func setSelectedConvenienceStoreCell(with page: Int) {
        viewHolder.convenienceStoreCollectionView.selectItem(
            at: IndexPath(item: page, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }
    
    private func requestProducts(store: ConvenienceStore) {
        listener?.didChangeStore(to: store)
    }
    
    private func configureNotificationButton() {
        viewHolder.titleNavigationView.delegate = self
    }
    
    func showNotificationList(_ viewController: ModernRIBs.ViewControllable) {
        let notificationListViewController = viewController.uiviewController
        
        notificationListViewController.modalPresentationStyle = .fullScreen
        present(notificationListViewController, animated: true)
    }
    
    func updateProducts(with products: [ConvenienceStore: [BrandProductEntity]]) {
        guard let viewController = viewHolder.productHomePageViewController.viewControllers?.first,
              let productListViewController = viewController as? ProductListViewController
        else {
            return
        }
        
        if let products = products[productListViewController.convenienceStore] {
            productListViewController.applySnapshot(with: products)
        }
    }
    
    func updateProducts(with products: [BrandProductEntity], at store: ConvenienceStore) {
        if let storeIndex = ConvenienceStore.allCases.firstIndex(of: store) {
            let pageViewController = viewHolder.productHomePageViewController
            let viewController = pageViewController.productListViewControllers[storeIndex]
            viewController.applySnapshot(with: products)
        }
    }
    
    func didFinishPaging() {
        isPaging = false
    }
}

//MARK: - TitleNavigationViewDelegate {
extension ProductHomeViewController: TitleNavigationViewDelegate {
    func didTabSearchButton() {
        listener?.didTapSearchButton()
    }
    
    func didTabNotificationButton() {
        listener?.didTapNotificationButton()
    }
}

//MARK: - UICollectionViewDataSource
extension ProductHomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return convenienceStores.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell: ConvenienceStoreCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ConvenienceStoreCell.self),
            for: indexPath
        ) as? ConvenienceStoreCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(title: convenienceStores[indexPath.item])
        
        if indexPath.item == initialIndex {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        return cell
    }
}

//MARK: - UIScrollViewDelegate
extension ProductHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageViewController = viewHolder.productHomePageViewController
        guard let currentViewController = pageViewController.viewControllers?.first,
              let productListViewController = currentViewController as? ProductListViewController
        else {
            return
        }
        
        let collectionView = productListViewController.productCollectionView
        let outerScroll = scrollView == viewHolder.containerScrollView
        let innerScroll = !outerScroll
        let swipeDirectionY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let downScroll = swipeDirectionY < 0
        let upScroll = swipeDirectionY > 0
        let outerScrollMaxOffset = viewHolder.titleNavigationView.frame.height
        
        if innerScroll && upScroll {
            guard viewHolder.containerScrollView.contentOffset.y > 0 else { return }
            
            let scrolledHeight = innerScrollLastOffsetY - scrollView.contentOffset.y
            let maxOffsetY = max(viewHolder.containerScrollView.contentOffset.y - scrolledHeight, 0)
            
            viewHolder.containerScrollView.contentOffset.y = maxOffsetY
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
        
        let paginationHeight = abs(collectionView.contentSize.height - collectionView.bounds.height) * 0.9

        if innerScroll && !isPaging && paginationHeight <= collectionView.contentOffset.y {
            isPaging = true
            listener?.didScrollToNextPage(store: ConvenienceStore.allCases[currentPage])
        }
        
        if innerScroll && downScroll {
            guard viewHolder.containerScrollView.contentOffset.y < outerScrollMaxOffset else { return }
  
            let scrolledHeight = scrollView.contentOffset.y - innerScrollLastOffsetY
            let minOffsetY = min(
                viewHolder.containerScrollView.contentOffset.y + scrolledHeight,
                outerScrollMaxOffset
            )
            let offsetY = max(minOffsetY, 0)
            
            viewHolder.containerScrollView.contentOffset.y = offsetY
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView != viewHolder.containerScrollView {
            innerScrollLastOffsetY = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView != viewHolder.containerScrollView {
            innerScrollLastOffsetY = scrollView.contentOffset.y
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProductHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellSize = ConvenienceStoreCell.Constant.Size.self
        let label = UILabel(frame: .zero)
        label.text = convenienceStores[indexPath.item]
        label.font = cellSize.font
        label.sizeToFit()

        return CGSize(
            width: label.frame.width + cellSize.padding.top + cellSize.padding.bottom,
            height: ConvenienceStoreCell.Constant.Size.height
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        let cellConstant = ConvenienceStoreCell.Constant.Size.self
        let cellSizes = convenienceStores.reduce(CGFloat(0), { partialResult, title in
            let label = UILabel(frame: .zero)
            label.text = title
            label.font = cellConstant.font
            label.sizeToFit()
            return partialResult + label.bounds.width + cellConstant.padding.left * 2
        })
        let result = (collectionView.bounds.width - cellSizes) / CGFloat(convenienceStores.count - 1)

        return floor(result * 10000) / 10000
    }
}

//MARK: - UICollectionViewDelegate
extension ProductHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == viewHolder.convenienceStoreCollectionView {
            currentPage = indexPath.item
            viewHolder.productHomePageViewController.updatePage(to: currentPage)
        } else {
            if let productListViewController =  viewHolder.productHomePageViewController.viewControllers?.first as? ProductListViewController,
               let item = productListViewController.dataSource?.itemIdentifier(for: indexPath) {
                listener?.didSelect(with: item)
            }
        }
    }
}

//MARK: - ProductHomePageViewControllerDelegate
extension ProductHomeViewController: ProductHomePageViewControllerDelegate {
    func didFinishPageTransition(index: Int) {
        currentPage = index
        setSelectedConvenienceStoreCell(with: currentPage)
    }
}

extension ProductHomeViewController: ProductListDelegate {
    func didLoadPageList(store: ConvenienceStore) {
        requestProducts(store: store)
    }
    
    func refreshByPull() {
        let store = ConvenienceStore.allCases[currentPage]
        requestProducts(store: store)
    }
    
    func didSelect(with brandProduct: ProductConvertable) {
    }
}

extension ProductHomeViewController: ProductPresentable {
    func didTabRootTabBar() {
        guard let viewController = viewHolder.productHomePageViewController.viewControllers?.first,
              let productListViewController = viewController as? ProductListViewController
        else {
            return
        }
        
        productListViewController.scrollCollectionViewToTop()
    }
    
}
