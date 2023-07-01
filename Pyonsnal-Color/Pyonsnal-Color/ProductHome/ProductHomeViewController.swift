//
//  ProductHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import UIKit

protocol ProductHomePresentableListener: AnyObject {
}

final class ProductHomeViewController:
    UIViewController,
    ProductHomePresentable,
    ProductHomeViewControllable {

    //MARK: - Interface
    weak var listener: ProductHomePresentableListener?
    
    //MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private let convenienceStores: [String] = ["전체", "CU", "GS25", "Emart24", "7-Eleven"]
    private let initialIndex: Int = 0
    private var innerScrollLastOffsetY: CGFloat = 0
    private var currentPage: Int = 0 {
        didSet {
            bind(lastIndex: oldValue, newIndex: currentPage)
        }
    }
    
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
    }
    
    private func bind(lastIndex: Int, newIndex: Int) {
        let isForward = lastIndex < newIndex
        let direction: UIPageViewController.NavigationDirection = isForward ? .forward : .reverse
        viewHolder.productHomePageViewController.setViewControllers(
            [viewHolder.productHomePageViewController.productListViewControllers[currentPage]],
            direction: direction,
            animated: true,
            completion: nil
        )
        
        viewHolder.convenienceStoreCollectionView.selectItem(
            at: IndexPath(item: currentPage, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
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
        guard let currentViewController = pageViewController.currentViewController else { return }
        
        let collectionView = currentViewController.productCollectionView
        let outerScroll = scrollView == viewHolder.containerScrollView
        let innerScroll = !outerScroll
        let downScroll = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        let upScroll = !downScroll
        let outerScrollMaxOffset = viewHolder.titleNavigationView.frame.height
        
        if innerScroll && upScroll {
            guard viewHolder.containerScrollView.contentOffset.y > 0 else { return }
            
            let scrolledHeight = innerScrollLastOffsetY - scrollView.contentOffset.y
            let maxOffsetY = max(viewHolder.containerScrollView.contentOffset.y - scrolledHeight, 0)
            
            viewHolder.containerScrollView.contentOffset.y = maxOffsetY
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
        
        if innerScroll && downScroll {
            guard viewHolder.containerScrollView.contentOffset.y < outerScrollMaxOffset else { return }
  
            let scrolledHeight = scrollView.contentOffset.y - innerScrollLastOffsetY
            let minOffsetY = min(
                viewHolder.containerScrollView.contentOffset.y + scrolledHeight,
                outerScrollMaxOffset
            )
            
            viewHolder.containerScrollView.contentOffset.y = minOffsetY
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
            height: label.frame.height + cellSize.padding.left + cellSize.padding.right
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
        currentPage = indexPath.item
    }
}

//MARK: - ProductHomePageViewControllerDelegate
extension ProductHomeViewController: ProductHomePageViewControllerDelegate {
    func didFinishPageTransition(index: Int) {
        currentPage = index
    }
}
