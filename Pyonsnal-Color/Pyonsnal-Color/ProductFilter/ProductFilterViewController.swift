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
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
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
        case sort
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
    }
    
    private func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func configureCollectionView() {
        viewHolder.collectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let section = ProductFilterSectionLayout().section(at: filterType)
        return  UICollectionViewCompositionalLayout(section: section)
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
        }
        
        private let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.makeRoundCorners(cornerRadius: 16, maskedCorners: .layerMinXMinYCorner)
            view.makeRoundCorners(cornerRadius: 16, maskedCorners: .layerMaxXMinYCorner)
            return view
        }()
        
        private let grabView: UIView = {
            let view = UIView()
            view.makeRounded(with: 2.5)
            view.backgroundColor = .gray200
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
        
        let collectionView: UICollectionView = .init(frame: .zero)
        
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
            containerView.addSubview(collectionView)
            containerView.addSubview(applyButton)
        }
        
        func configureConstraints(for view: UIView) {
            containerView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalTo(view)
            }
            
            grabView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(containerView.snp.bottom).offset(Size.grabViewTop)
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
            
            collectionView.snp.makeConstraints {
                $0.leading.trailing.equalTo(applyButton)
                $0.top.equalTo(titleLabel).offset(Spacing.spacing24.value)
                $0.bottom.equalTo(applyButton).inset(Spacing.spacing40.value)
            }
            
            applyButton.snp.makeConstraints {
                $0.leading.equalTo(titleLabel)
                $0.trailing.equalToSuperview().inset(Size.titleLeading)
                $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom)
                $0.bottom.equalToSuperview().inset(.spacing16).priority(.low)
            }
        }
    }
}
