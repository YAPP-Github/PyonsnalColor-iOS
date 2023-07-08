//
//  EventHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import UIKit
import ModernRIBs
import SnapKit

protocol EventHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didTapEventBannerCell(with imageUrl: String)
    func didTapProductCell()
}

struct Tab: Hashable {
    var id = UUID()
    var name: String
    var isSelected: Bool = false
    
    mutating func updateSelectedState() {
        isSelected = false
    }
}

final class EventHomeViewController: UIViewController,
                                     EventHomePresentable,
                                     EventHomeViewControllable {
    
    enum Size {
        static let titleLabelLeading: CGFloat = 16
        static let headerMargin: CGFloat = 11
        static let notificationButtonTrailing: CGFloat = 17
        static let headerViewHeight: CGFloat = 50
        static let collectionViewTop: CGFloat = 20
        static let collectionViewLeaing: CGFloat = 16
    }
    
    enum Header {
        static let title = "행사 상품 모아보기"
    }
    
    enum TabBarItem {
        static let title = "행사"
    }
    
    weak var listener: EventHomePresentableListener?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    private var innerScrollLastOffsetY: CGFloat = 0
    private var tabData: [Tab] = []
    private var initIndex: Int = 0
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureDummyData()
        configureTabCollectionView()
        setPageViewController()
        setScrollView()
        configureUI()
    }
    
    // MARK: - Private method
    private func configureDummyData() {
        tabData = [Tab(name: "전체"),
                   Tab(name: "CU"),
                   Tab(name: "GS25"),
                   Tab(name: "Emart24"),
                   Tab(name: "7-eleven")]
    }
    
    private func configureTabCollectionView() {
        viewHolder.convenienceStoreCollectionView.delegate = self
        viewHolder.convenienceStoreCollectionView.dataSource = self
        viewHolder.convenienceStoreCollectionView.register(ConvenienceStoreCell.self)
    }
    
    private func setPageViewController() {
        addChild(viewHolder.pageViewController)
        viewHolder.pageViewController.didMove(toParent: self)
        viewHolder.pageViewController.pageDelegate = self
        viewHolder.pageViewController.scrollDelegate = self
    }
    
    private func setScrollView() {
        viewHolder.containerScrollView.delegate = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func setupTabBarItem() {
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: TabBarItem.title,
            image: UIImage(named: ImageAssetKind.event.rawValue),
            selectedImage: UIImage(named: ImageAssetKind.eventSelected.rawValue)
        )
    }
    
    private func setSelectedConvenienceStoreCell(with indexPath: IndexPath) {
        viewHolder.convenienceStoreCollectionView.selectItem(at: indexPath,
                                                             animated: true,
                                                             scrollPosition: .init())
    }
    
}

// MARK: - UI Component
extension EventHomeViewController {
    
    class ViewHolder: ViewHolderable {
        private let headerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = Header.title
            label.font = .title2
            return label
        }()
        
        private let notificationButton: UIButton = {
            let button = UIButton()
            button.setImage(.bellSimple, for: .normal)
            return button
        }()
        
        let containerScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.bounces = false
            return scrollView
        }()
        
        let convenienceStoreCollectionView: UICollectionView = {
            let flowLayout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: flowLayout)
            collectionView.showsHorizontalScrollIndicator = false
            return collectionView
        }()
        
        private let contentView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        private let contentPageView: UIView = {
            let view = UIView()
            return view
        }()
        
        lazy var pageViewController = EventHomePageViewController(transitionStyle: .scroll,
                                                                  navigationOrientation: .horizontal)
        func place(in view: UIView) {
            view.addSubview(containerScrollView)
            containerScrollView.addSubview(contentView)
            contentView.addSubview(headerView)
            headerView.addSubview(titleLabel)
            headerView.addSubview(notificationButton)
            contentView.addSubview(convenienceStoreCollectionView)
            contentView.addSubview(contentPageView)
            contentPageView.addSubview(pageViewController.view)
        }
        
        func configureConstraints(for view: UIView) {
            containerScrollView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            
            contentView.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(containerScrollView.frameLayoutGuide.snp.height).priority(.low)
                $0.top.bottom.equalToSuperview()
            }
            
            headerView.snp.makeConstraints {
                $0.height.equalTo(Size.headerViewHeight)
                $0.top.leading.trailing.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Size.titleLabelLeading)
                $0.top.equalToSuperview().offset(Size.headerMargin)
                $0.centerY.equalToSuperview()
            }
            
            notificationButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(Size.notificationButtonTrailing)
                $0.top.equalToSuperview().offset(Size.headerMargin)
                $0.centerY.equalToSuperview()
            }
            
            convenienceStoreCollectionView.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom)
                $0.leading.equalToSuperview().offset(Size.collectionViewLeaing)
                $0.trailing.equalToSuperview().inset(Size.collectionViewLeaing)
                $0.height.equalTo(ConvenienceStoreCell.Constant.Size.height)
            }
            
            contentPageView.snp.makeConstraints {
                $0.top.equalTo(convenienceStoreCollectionView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }

            pageViewController.view.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
}

// MARK: - EventHomePageViewControllerDelegate
extension EventHomeViewController: EventHomePageViewControllerDelegate {
    func updateSelectedStoreCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        setSelectedConvenienceStoreCell(with: indexPath)
    }
    
    func didTapEventBannerCell(with imageUrl: String) {
        listener?.didTapEventBannerCell(with: imageUrl)
    }
    
    func didTapProductItemCell() {
        listener?.didTapProductCell()
    }
}

// MARK: - UICollectionViewDataSource
extension EventHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConvenienceStoreCell.className, for: indexPath) as? ConvenienceStoreCell else { return UICollectionViewCell() }
        cell.configureCell(title: tabData[indexPath.row].name)
        if indexPath.row == initIndex { // 초기 상태 selected
            setSelectedConvenienceStoreCell(with: indexPath)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EventHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == viewHolder.convenienceStoreCollectionView {
            setSelectedConvenienceStoreCell(with: indexPath)
            viewHolder.pageViewController.updatePage(indexPath.row)
        }
    }
}

extension EventHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConvenienceStoreCell.className, for: indexPath) as? ConvenienceStoreCell {
            cell.configureCell(title: tabData[indexPath.row].name)
            let width = cell.getWidth()
            return CGSize(width: width,
                          height: ConvenienceStoreCell.Constant.Size.height)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //device에 따라 dynamic interspacing 대응
        let cellConstant = ConvenienceStoreCell.Constant.Size.self
        let cellSizes = tabData.reduce(CGFloat(0), { partialResult, title in
            let label = UILabel(frame: .zero)
            label.text = title.name
            label.font = cellConstant.font
            label.sizeToFit()
            return partialResult + label.bounds.width + cellConstant.padding.left * 2
        })
        let result = (collectionView.bounds.width - cellSizes) / CGFloat(tabData.count - 1)
        
        return floor(result * 10000) / 10000
    }
}

// MARK: - UIScrollViewDelegate
extension EventHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = viewHolder.pageViewController.currentViewController?.collectionView else { return }

        let outerScroll = scrollView == viewHolder.containerScrollView
        let innerScroll = !outerScroll
        let downScroll = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        let upScroll = !downScroll
        let outerScrollMaxOffset: CGFloat = Size.headerViewHeight
        
        
        if innerScroll && upScroll {
            //안쪽을 위로 스크롤할때 바깥쪽 스크롤뷰의 contentOffset을 0으로 줄이기
            guard viewHolder.containerScrollView.contentOffset.y > 0 else { return }
            let scrolledHeight = innerScrollLastOffsetY - scrollView.contentOffset.y
            let maxOffsetY = max(viewHolder.containerScrollView.contentOffset.y - scrolledHeight, 0)
            
            viewHolder.containerScrollView.contentOffset.y = maxOffsetY
            // 스크롤뷰의 contentOffset을 내림
            collectionView.contentOffset.y = innerScrollLastOffsetY
        }
        
        if innerScroll && downScroll {
            //안쪽을 아래로 스크롤할때 바깥쪽 먼저 아래로 스크롤
            guard viewHolder.containerScrollView.contentOffset.y < outerScrollMaxOffset else { return }
  
            let minOffsetY = min(viewHolder.containerScrollView.contentOffset.y + scrollView.contentOffset.y - innerScrollLastOffsetY, outerScrollMaxOffset)
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

// MARK: - ScrollDelegate
extension EventHomeViewController: ScrollDelegate {
    func didScroll(scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
    
    func willBeginDragging(scrollView: UIScrollView) {
        self.scrollViewWillBeginDragging(scrollView)
    }
    
    func didEndDragging(scrollView: UIScrollView) {
        self.scrollViewDidEndDragging(scrollView, willDecelerate: false)
    }
}
