//
//  ProductSearchViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import ModernRIBs
import UIKit
import Combine

enum ProductCellType: Hashable {
    case empty
    case item(EventProductEntity)
}

protocol ProductSearchPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func popViewController()
    func search(with keyword: String?)
    func loadMoreItems()
}

final class ProductSearchViewController: UIViewController,
                                         ProductSearchPresentable,
                                         ProductSearchViewControllable {
    
    // MARK: - Declaration
    enum Constant {
        enum Size {
            static let collectionViewLineSpacing: CGFloat = 12
            static let collectionViewItemSpacing: CGFloat = 12
            static let collectionViewEdgeInset: UIEdgeInsets = .init(
                top: 16, left: 16, bottom: 40, right: 16
            )
            static let collectionViewLoadingFooterHeight: CGFloat = 50
        }
    }
    
    enum Section: CaseIterable {
        case main
    }
    
    weak var listener: ProductSearchPresentableListener?
    
    // MARK: - Private Method
    private let viewHolder: ViewHolder = .init()
    private var dataSource: UICollectionViewDiffableDataSource<Section, ProductCellType>?
    private let textSubject = PassthroughSubject<String?, Never>()
    private var cancellable = Set<AnyCancellable>()
    private var isCanLoading: Bool = false
    private var isEmpty: Bool = true
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        
        configureUI()
        configureAction()
        bind()
    }
    
    // MARK: - Private Method
    private func bind() {
        textSubject
            .throttle(for: 1, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] text in
                self?.listener?.search(with: text)
            }
            .store(in: &cancellable)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureCollectionView()
    }
    
    private func configureAction() {
        viewHolder.backButton.addTarget(
            self,
            action: #selector(backButtonAction(_:)),
            for: .touchUpInside
        )
        viewHolder.searchBarView.delegate = self
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.delegate = self
        viewHolder.collectionView.register(ProductCell.self)
        viewHolder.collectionView.register(EmptyCell.self)
        viewHolder.collectionView.registerFooterView(LoadingReusableView.self)
        
        dataSource = .init(
            collectionView: viewHolder.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .empty:
                    let cell: EmptyCell = collectionView.dequeueReusableCell(for: indexPath)
                    return cell
                case let .item(product):
                    let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.updateCell(with: product)
                    return cell
                }
            }
        )
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return UICollectionReusableView()
            case UICollectionView.elementKindSectionFooter:
                let loading = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: String(describing: LoadingReusableView.self),
                    for: indexPath
                )
                return loading
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    func presentProducts(with items: [ProductCellType], isCanLoading: Bool) {
        self.isEmpty = items.first == .empty
        self.isCanLoading = isCanLoading
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductCellType>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        OperationQueue.main.addOperation {
            self.dataSource?.apply(snapshot)
        }
    }
    
    @objc private func backButtonAction(_ sender: UIButton) {
        listener?.popViewController()
    }
}

extension ProductSearchViewController: SearchBarViewDelegate {
    func updateText(_ text: String?) {
        textSubject.send(text)
    }
}

extension ProductSearchViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            listener?.loadMoreItems()
        }
    }
}

extension ProductSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        if isCanLoading {
            return .init(
                width: collectionView.bounds.width,
                height: Constant.Size.collectionViewLoadingFooterHeight
            )
        } else {
            return .zero
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if isEmpty {
            return collectionView.bounds.size
        } else {
            let itemSpacing = Constant.Size.collectionViewItemSpacing
            let edgeInsetLeft = Constant.Size.collectionViewEdgeInset.left
            let edgeInsetRight = Constant.Size.collectionViewEdgeInset.right
            let spacing = itemSpacing + edgeInsetLeft + edgeInsetRight
            let collectionViewWidth = collectionView.bounds.width
            let cellHeightRatio: CGFloat = 1.294797
            
            let cellWidth = (collectionViewWidth - spacing) / 2
            let cellHeight = cellWidth * cellHeightRatio
            
            return .init(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        if isEmpty {
            return .zero
        } else {
            return Constant.Size.collectionViewItemSpacing
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        if isEmpty {
            return .zero
        } else {
            return Constant.Size.collectionViewLineSpacing
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if isEmpty {
            return .zero
        } else {
            return Constant.Size.collectionViewEdgeInset
        }
    }
}
