//
//  ProductFilterViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/25.
//

import UIKit
import ModernRIBs
import SnapKit

protocol ProductFilterPresentableListener: AnyObject {
}

final class ProductFilterViewController: UIViewController, ProductFilterPresentable, ProductFilterViewControllable {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    enum Text {
        static let sortTitle = "정렬 선택"
        static let eventTitle = "행사"
        static let categoryTitle = "카테고리"
        static let recommendationTitle = "상품추천"
    }
    
    enum Section: Hashable {
        case sort
        case event
        case category
        case recommendation
    }
    
    enum Item: Hashable {
        case sort(index: Int)
        case event
        case category
        case recommendation
    }

    weak var listener: ProductFilterPresentableListener?
    
    private let viewHolder = ViewHolder()
    private var dataSource: DataSource?
    private let filterType: Section = .sort
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureView()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        resizeCollectionViewHeight()
    }
    
    private func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        let title: String
        
        switch filterType {
        case .sort:
            title = Text.sortTitle
        default:
            title = ""
        }
        
        viewHolder.titleLabel.text = title
        hideApplyButton()
    }
    
    private func hideApplyButton() {
        viewHolder.applyButton.isHidden = filterType == .sort ? true : false
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.setCollectionViewLayout(createLayout(), animated: true)
        registerCells()
        configureDataSource()
        applySnapshot()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let section = ProductFilterSectionLayout().section(at: filterType)
        return  UICollectionViewCompositionalLayout(section: section)
    }
    
    private func registerCells() {
        viewHolder.collectionView.register(SortFilterCell.self)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: viewHolder.collectionView
        ) { collectionView, index, item in
            switch item {
            case .sort:
                let cell: SortFilterCell = collectionView.dequeueReusableCell(for: index)
                cell.configureCell(at: index.item)
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.sort])
        snapshot.appendItems([.sort(index: 1), .sort(index: 2), .sort(index: 3)])
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func resizeCollectionViewHeight() {
        let height = viewHolder.collectionView.contentSize.height
        
        if height > 0 {
            viewHolder.collectionView.snp.makeConstraints {
                $0.height.equalTo(height)
            }
        }
    }
}

extension ProductFilterViewController {
    final class ViewHolder: ViewHolderable {
        
        enum Text {
            static let applyTitle: String = "적용하기"
        }
        
        enum Size {
            static let grabViewSize: CGSize = .init(width: 36, height: 5)
            static let grabViewTop: CGFloat = 5
            static let titleLeading: CGFloat = 20
            static let titleTop: CGFloat = 40
            static let applyButtonHeight: CGFloat = 52
        }
        
        private let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.makeRoundCorners(
                cornerRadius: 16,
                maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            )
            return view
        }()
        
        private let grabView: UIView = {
            let view = UIView()
            view.makeRounded(with: 2.5)
            view.backgroundColor = .gray400
            return view
        }()
        
        let closeButton: UIButton = {
            let button = UIButton()
            button.setImage(.iconClose, for: .normal)
            return button
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            label.textColor = .black
            return label
        }()
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = Spacing.spacing40.value
            return stackView
        }()
        
        let collectionView: UICollectionView = {
            let collectionView = UICollectionView(
                frame: .zero,
                collectionViewLayout: UICollectionViewLayout()
            )
            collectionView.isScrollEnabled = false
            return collectionView
        }()
        
        let applyButton: PrimaryButton = {
            let button = PrimaryButton(state: .disabled)
            button.setText(with: Text.applyTitle)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerView)
            
            containerView.addSubview(grabView)
            containerView.addSubview(closeButton)
            containerView.addSubview(titleLabel)
            containerView.addSubview(stackView)
            
            stackView.addArrangedSubview(collectionView)
            stackView.addArrangedSubview(applyButton)
        }
        
        func configureConstraints(for view: UIView) {
            containerView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalTo(view)
            }
            
            grabView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(containerView).offset(Size.grabViewTop)
                $0.size.equalTo(Size.grabViewSize)
            }
            
            closeButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(Spacing.spacing12.value)
                $0.trailing.equalToSuperview().inset(Spacing.spacing12.value)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Size.titleLeading)
                $0.top.equalToSuperview().offset(Size.titleTop)
            }
            
            stackView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Size.titleLeading)
                $0.trailing.equalToSuperview().inset(Size.titleLeading)
                $0.top.equalTo(titleLabel.snp.bottom).offset(Spacing.spacing24.value)
            }
            
            collectionView.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(90)
                $0.bottom.lessThanOrEqualTo(
                    view.safeAreaLayoutGuide
                ).inset(Spacing.spacing40.value).priority(.low)
            }
            
            applyButton.snp.makeConstraints {
                $0.height.equalTo(Size.applyButtonHeight)
                $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).priority(.high)
                $0.bottom.equalTo(containerView).inset(.spacing16).priority(.medium)
            }
        }
    }
}
