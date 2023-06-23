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
    private let dataSource: [String] = ["전체", "CU", "GS25", "Emart24", "7-Eleven"]
    private var innerScrollLastOffsetY: CGFloat = 0
    
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
        let customFont = UIFont.customFont(weight: .medium, size: 12)
        
        tabBarItem.setTitleTextAttributes([.font: customFont], for: .normal)
        tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        view.backgroundColor = .white
        viewHolder.containerScrollView.delegate = self
    }
    
    private func setupStoreCollectionView() {
        viewHolder.convenienceStoreCollectionView.dataSource = self
        viewHolder.convenienceStoreCollectionView.delegate = self
    }
    
    private func setupProductCollectionView() {
        viewHolder.convenienceStorePageViewController.productListViewControllers.forEach {
            $0.productCollectionView.delegate = self
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ProductHomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return dataSource.count
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
        
        cell.configureCell(title: dataSource[indexPath.item])
        
        if indexPath.item == 0 {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        return cell
    }
}

//MARK: - UIScrollViewDelegate
extension ProductHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentViewController = viewHolder.convenienceStorePageViewController.currentViewController else {
            return
        }
        
        let collectionView = currentViewController.productCollectionView
        let outerScroll = scrollView == viewHolder.containerScrollView
        let innerScroll = !outerScroll
        let downScroll = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        let upScroll = !downScroll
        let outerScrollMaxOffset = viewHolder.headerStackView.frame.height
        
        if innerScroll && upScroll {
            guard viewHolder.containerScrollView.contentOffset.y > 0 else { return }
            
            let scrolledHeight = innerScrollLastOffsetY - scrollView.contentOffset.y
            let maxOffsetY = max(viewHolder.containerScrollView.contentOffset.y - scrolledHeight, 0)
            let offsetY = min(maxOffsetY, outerScrollMaxOffset)
            
            viewHolder.containerScrollView.contentOffset.y = offsetY
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
        
        if innerScroll && downScroll {
            guard viewHolder.containerScrollView.contentOffset.y < outerScrollMaxOffset else { return }
  
            let scrolledHeight = scrollView.contentOffset.y - innerScrollLastOffsetY
            let minOffsetY = min(viewHolder.containerScrollView.contentOffset.y + scrolledHeight ,outerScrollMaxOffset)
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
        let label = UILabel(frame: .zero)
        label.text = dataSource[indexPath.item]
        label.font = UIFont.body3m
        label.sizeToFit()

        return CGSize(
            width: label.frame.width + Constant.Size.leftRightMargin * 2,
            height: label.frame.height + Constant.Size.headerBottomInset * 2
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        let cellSizes = dataSource.reduce(CGFloat(0), { partialResult, title in
            let label = UILabel(frame: .zero)
            label.text = title
            label.font = UIFont.body3m
            label.sizeToFit()
            return partialResult + label.bounds.width + Constant.Size.leftRightMargin * 2
        })
        let result = (collectionView.bounds.width - cellSizes) / CGFloat(dataSource.count - 1)

        return floor(result * 10000) / 10000
    }
}
