//
//  FavoriteViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import UIKit
import SnapKit
import ModernRIBs
import Combine

protocol FavoritePresentableListener: AnyObject {
    func requestFavoriteProducts()
    func deleteAllProducts()
    func appendProduct(product: any ProductConvertable)
    func deleteProduct(product: any ProductConvertable)
    func didTapSearchButton()
    func didSelect(with product: any ProductConvertable)
}

final class FavoriteViewController: UIViewController,
                                    FavoritePresentable,
                                    FavoriteViewControllable {

    enum Size {
        static let headerViewHeight: CGFloat = 48
        static let stackViewHeight: CGFloat = 40
        static let underBarHeight: CGFloat = 3
    }
    
    enum Text {
        static let tabBarItem = "찜"
        static let productTab = "차별화 상품"
        static let eventTab = "행사 상품"
    }
    
    enum Tab: Int {
        case product = 0
        case event
    }
    
    weak var listener: FavoritePresentableListener?
    private let viewHolder: ViewHolder = .init()
    private var products = [[any ProductConvertable]]()
    private var scrollIndex = PassthroughSubject<Int, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listener?.requestFavoriteProducts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: self.view)
        viewHolder.configureConstraints(for: self.view)
        setTabSelectedState(to: .product)
        configureAction()
        configureCollectionView()
        configureNavigationView()
        configureRefreshControl()
        bindActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.deleteAllProducts()
    }
    
    func updateProducts(products: [[any ProductConvertable]]) {
        self.products = products
        viewHolder.collectionView.reloadData()
        self.endRefreshing()
    }
    
    private func configureTabBarItem() {
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: Text.tabBarItem,
            image: ImageAssetKind.TabBar.favoriteUnSelected.image,
            selectedImage: ImageAssetKind.TabBar.favoriteSelected.image
        )
    }
    
    private func setTabSelectedState(to state: Tab) {
        switch state {
        case .product:
            setSelectedState(
                button: viewHolder.productTabButton,
                underBarView: viewHolder.productUnderBarView
            )
            setUnSelectedState(
                button: viewHolder.eventTabButton,
                underBarView: viewHolder.eventUnderBarView
            )
        case .event:
            setSelectedState(
                button: viewHolder.eventTabButton,
                underBarView: viewHolder.eventUnderBarView
            )
            setUnSelectedState(
                button: viewHolder.productTabButton,
                underBarView: viewHolder.productUnderBarView
            )
        }
    }
    
    private func setSelectedState(button: UIButton, underBarView: UIView) {
        button.isSelected = true
        underBarView.isHidden = false
    }
    
    private func setUnSelectedState(button: UIButton, underBarView: UIView) {
        button.isSelected = false
        underBarView.isHidden = true
    }
    
    private func configureAction() {
        viewHolder.productTabButton.addTarget(
            self,
            action: #selector(didTapProductButton),
            for: .touchUpInside
        )
        viewHolder.eventTabButton.addTarget(
            self,
            action: #selector(didTapEventButton),
            for: .touchUpInside
        )
    }
    
    @objc
    func didTapProductButton() {
        let selectedTab: Tab = .product
        self.selectTabAndScrollToItem(tab: selectedTab)
    }
    
    @objc
    func didTapEventButton() {
        let selectedTab: Tab = .event
        self.selectTabAndScrollToItem(tab: selectedTab)
    }
    
    private func selectTabAndScrollToItem(tab: Tab) {
        self.setTabSelectedState(to: tab)
        let indexPath = IndexPath(item: tab.rawValue, section: 0)
        viewHolder.collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.register(FavoriteProductContainerCell.self)
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.dataSource = self
    }
    
    private func configureNavigationView() {
        viewHolder.titleNavigationView.delegate = self
    }
    
    private func configureRefreshControl() {
        viewHolder.collectionView.refreshControl?.addTarget(
            self,
            action: #selector(pullToRefresh),
            for: .valueChanged
        )
    }
    
    @objc func pullToRefresh() {
        viewHolder.collectionView.refreshControl?.beginRefreshing()
        listener?.requestFavoriteProducts()
    }
    
    func endRefreshing() {
        viewHolder.collectionView.refreshControl?.endRefreshing()
    }
    
    private func bindActions() {
        scrollIndex
            .sink { [weak self] index in
            let tab = Tab(rawValue: index) ?? .product
            self?.setTabSelectedState(to: tab)
        }.store(in: &cancellable)
        
    }
    
    final class ViewHolder: ViewHolderable {
        let titleNavigationView: TitleNavigationView = {
            let view = TitleNavigationView()
            view.updateTitleLabel(with: Text.tabBarItem)
            return view
        }()
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
            return stackView
        }()
        
        private let dividerView: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .gray200
            return view
        }()
        
        private let productSubView: UIView = {
            let view = UIView()
            return view
        }()
        
        let productTabButton: UIButton = {
            let button = UIButton()
            button.setText(with: Text.productTab)
            button.titleLabel?.font = .label1
            button.setTitleColor(.black, for: .selected)
            button.setTitleColor(.gray400, for: .normal)
            return button
        }()
        
        private let eventSubView: UIView = {
            let view = UIView()
            return view
        }()
        
        let eventTabButton: UIButton = {
            let button = UIButton()
            button.setText(with: Text.eventTab)
            button.titleLabel?.font = .label1
            button.setTitleColor(.black, for: .selected)
            button.setTitleColor(.gray400, for: .normal)
            return button
        }()
        
        let productUnderBarView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            return view
        }()
        
        let eventUnderBarView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            return view
        }()
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.isPagingEnabled = true
            collectionView.bounces = false
            collectionView.refreshControl = UIRefreshControl()
            collectionView.showsHorizontalScrollIndicator = false
            return collectionView
        }()
        
        func place(in view: UIView) {
            view.addSubview(titleNavigationView)
            view.addSubview(stackView)
            view.addSubview(dividerView)
            stackView.addArrangedSubview(productSubView)
            stackView.addArrangedSubview(eventSubView)
            productSubView.addSubview(productTabButton)
            productSubView.addSubview(productUnderBarView)
            eventSubView.addSubview(eventTabButton)
            eventSubView.addSubview(eventUnderBarView)
            view.addSubview(collectionView)
        }
        
        func configureConstraints(for view: UIView) {
            titleNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.height.equalTo(Size.headerViewHeight)
                $0.leading.trailing.equalToSuperview()
            }
            
            stackView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.top.equalTo(titleNavigationView.snp.bottom)
                $0.height.equalTo(Size.stackViewHeight)
            }
            
            dividerView.snp.makeConstraints { make in
                make.height.equalTo(Size.dividerViewHeight)
                make.bottom.equalTo(stackView.snp.bottom)
                make.leading.trailing.equalToSuperview()
            }
            
            productTabButton.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            
            eventTabButton.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            
            productUnderBarView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(Size.underBarHeight)
            }
            
            eventUnderBarView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(Size.underBarHeight)
            }
            
            collectionView.snp.makeConstraints {
                $0.top.equalTo(stackView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        }

    }

}

extension FavoriteViewController: TitleNavigationViewDelegate {
    func didTabSearchButton() {
        listener?.didTapSearchButton()
    }
    
    func didTabNotificationButton() {
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoriteProductContainerCell = collectionView.dequeueReusableCell(for: indexPath)
        if products.isEmpty { return cell }
        let product = products[indexPath.item]
        cell.delegate = self
        cell.update(with: product)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        scrollIndex.send(currentIndex)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

// MARK: - FavoriteProductContainerCellDelegate
extension FavoriteViewController: FavoriteProductContainerCellDelegate {
    func didTapProduct(product: any ProductConvertable) {
        listener?.didSelect(with: product)
    }
    
    func didTapFavoriteButton(product: any ProductConvertable, action: FavoriteButtonAction) {
        switch action {
        case .add:
            listener?.appendProduct(product: product)
        case .delete:
            listener?.deleteProduct(product: product)
        }
    }
}
