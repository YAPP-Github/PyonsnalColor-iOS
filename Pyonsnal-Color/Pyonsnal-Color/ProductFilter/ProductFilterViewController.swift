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
    // TODO: 엔티티 변경
    func didTapApplyButton(with selectedItems: [String])
    func didTapCloseButton()
}

final class ProductFilterViewController:
    UIViewController,
    ProductFilterPresentable,
    ProductFilterViewControllable {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    enum Text {
        static let sortTitle = "정렬 선택"
        static let eventTitle = "행사"
        static let categoryTitle = "카테고리"
        static let recommendationTitle = "상품추천"
    }
    
    enum DummyData {
        
        enum Sort: String, CaseIterable {
            case recent = "최신순"
            case lowestPrice = "낮은 가격 순"
            case highestPrice = "높은 가격 순"
        }
        
        enum Event: String, CaseIterable {
            case onePlusOne = "1+1"
            case twoPlusOne = "2+1"
            case discount = "할인"
            case giftItem = "증정"
        }
        
        enum Category: String, CaseIterable {
            case food = "식품"
            case bakery = "베이커리"
            case snack = "과자류"
            case beverage = "음료"
            case iceCream = "아이스크림"
            case dailyGoods = "생활용품"
        }
        
        enum Recommend: String, CaseIterable {
            case food = "식품"
            case bakery = "베이커리"
            case snack = "과자류"
            case beverage = "음료"
            case iceCream = "아이스크림"
            case dailyGoods = "생활용품"
            case beer = "맥주"
            case cigarette = "담배"
        }
    }
    
    enum Section: Hashable {
        case sort
        case event
        case category
        case recommendation
    }
    
    enum Item: Hashable {
        case sort(title: String, selected: Bool)
        case event(title: String, selected: Bool)
        case category(title: String, selected: Bool)
        case recommendation(title: String, selected: Bool)
    }

    weak var listener: ProductFilterPresentableListener?
    
    private let viewHolder = ViewHolder()
    private var dataSource: DataSource?
    private let filterType: Section
    
    init(filterType: Section) {
        self.filterType = filterType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        view.backgroundColor = .black.withAlphaComponent(0.7)
        setFilterTitle()
        setMultiSelect()
        hideApplyButton()
    }
    
    private func setFilterTitle() {
        let title: String
        
        switch filterType {
        case .sort:
            title = Text.sortTitle
        case .event:
            title = Text.eventTitle
        case .category:
            title = Text.categoryTitle
        case .recommendation:
            title = Text.recommendationTitle
        }
        
        viewHolder.titleLabel.text = title
    }
    
    private func setMultiSelect() {
        viewHolder.collectionView.allowsMultipleSelection = filterType == .sort ? false : true
    }
    
    private func hideApplyButton() {
        viewHolder.applyButton.isHidden = filterType == .sort ? true : false
    }
    
    private func configureButtonsAction() {
        viewHolder.applyButton.addTarget(
            self,
            action: #selector(didTapApplyButton),
            for: .touchUpInside
        )
        viewHolder.closeButton.addTarget(
            self,
            action: #selector(didTapCloseButton),
            for: .touchUpInside
        )
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.setCollectionViewLayout(createLayout(), animated: true)
        viewHolder.collectionView.delegate = self
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
        viewHolder.collectionView.register(EventFilterCell.self)
        viewHolder.collectionView.register(CategoryFilterCell.self)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: viewHolder.collectionView
        ) { collectionView, index, item in
            switch item {
            case let .sort(title, isSelected):
                let cell: SortFilterCell = collectionView.dequeueReusableCell(for: index)
                cell.configureCell(title: title, isSelected: isSelected)
                return cell
            case let .event(title, isSelected):
                let cell: EventFilterCell = collectionView.dequeueReusableCell(for: index)
                cell.configureCell(title: title, isSelected: isSelected)
                return cell
            case let .category(title, isSelected), let .recommendation(title, isSelected):
                let cell: CategoryFilterCell = collectionView.dequeueReusableCell(for: index)
                cell.configureCell(title: title, isSelected: isSelected)
                return cell
            }
        }
    }
    
    // TODO: 외부 데이터 받아오도록 수정
    private func applySnapshot() {
        let dummyData: [Item] = {
            switch filterType {
            case .sort:
                return DummyData.Sort.allCases.map { .sort(title: $0.rawValue, selected: false) }
            case .event:
                return DummyData.Event.allCases.map { .event(title: $0.rawValue, selected: false) }
            case .category:
                return DummyData.Category.allCases.map { .category(title: $0.rawValue, selected: false) }
            case .recommendation:
                return DummyData.Recommend.allCases.map { .recommendation(title: $0.rawValue, selected: false) }
            }
        }()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([filterType])
        snapshot.appendItems(dummyData)
        
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
    
    private func setApplyButtonState() {
        guard filterType != .sort else { return }
        
        if viewHolder.collectionView.indexPathsForSelectedItems?.count == 0 {
            viewHolder.applyButton.setState(with: .disabled)
        } else {
            viewHolder.applyButton.setState(with: .enabled)
        }
    }
    
    @objc private func didTapApplyButton() {
        listener?.didTapApplyButton(with: [])
    }
    
    @objc private func didTapCloseButton() {
        listener?.didTapCloseButton()
    }
}

extension ProductFilterViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        setApplyButtonState()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        setApplyButtonState()
    }
}

extension ProductFilterViewController {
    final class ViewHolder: ViewHolderable {
        
        enum Text {
            static let applyTitle: String = "적용하기"
        }
        
        enum Size {
            static let containerViewRadius: CGFloat = 16
            static let grabViewRadius: CGFloat = 2.5
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
                cornerRadius: Size.containerViewRadius,
                maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            )
            return view
        }()
        
        private let grabView: UIView = {
            let view = UIView()
            view.makeRounded(with: Size.grabViewRadius)
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
            stackView.spacing = .spacing40
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
                $0.top.equalToSuperview().offset(.spacing12)
                $0.trailing.equalToSuperview().inset(.spacing12)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Size.titleLeading)
                $0.top.equalToSuperview().offset(Size.titleTop)
            }
            
            stackView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Size.titleLeading)
                $0.trailing.equalToSuperview().inset(Size.titleLeading)
                $0.top.equalTo(titleLabel.snp.bottom).offset(.spacing24)
            }
            
            collectionView.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(90)
                $0.bottom.lessThanOrEqualTo(
                    view.safeAreaLayoutGuide
                ).inset(.spacing40).priority(.low)
            }
            
            applyButton.snp.makeConstraints {
                $0.height.equalTo(Size.applyButtonHeight)
                $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).priority(.high)
                $0.bottom.equalTo(containerView).inset(.spacing16).priority(.medium)
            }
        }
    }
}
