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
        
        view.backgroundColor = .systemGray6
    }
    
    private func setupStoreCollectionView() {
        viewHolder.convenienceStoreCollectionView.dataSource = self
        viewHolder.convenienceStoreCollectionView.delegate = self
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
            withReuseIdentifier: ConvenienceStoreCell.identifier,
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
