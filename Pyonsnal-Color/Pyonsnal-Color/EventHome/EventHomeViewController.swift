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
        static let tabCollectionViewHeight: CGFloat = 44
        static let headerViewHeight: CGFloat = 50
        static let collectionViewTop: CGFloat = 20
    }
    
    weak var listener: EventHomePresentableListener?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    private var innerScrollLastOffsetY: CGFloat = 0
    private var tabData: [Tab] = []

    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
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
        tabData = [Tab(name: "전체", isSelected: true),
                                      Tab(name: "GS25"),
                                      Tab(name: "이마트24"),
                                      Tab(name: "세븐일레븐"),
                                      Tab(name: "CU")]
    }
    
    private func configureTabCollectionView() {
        viewHolder.tabCollectionView.delegate = self
        viewHolder.tabCollectionView.dataSource = self
        viewHolder.tabCollectionView.register(TabCell.self, forCellWithReuseIdentifier: TabCell.className)
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
        view.backgroundColor = .systemGray6
    }
    
    private func updateSelectedTabCell(with index: Int) {
        for index in 0..<tabData.count {
            tabData[index].updateSelectedState()
        }
        tabData[index].isSelected = true
        viewHolder.tabCollectionView.reloadData()
    }
    
    private func setupViews() {
        let customFont: UIFont = .label2
        
        tabBarItem.setTitleTextAttributes([.font: customFont], for: .normal)
        tabBarItem = UITabBarItem(
            title: "행사",
            image: UIImage(named: "event"),
            selectedImage: UIImage(named: "event.selected")
        )
    }

}

// MARK: - UI Component
extension EventHomeViewController {
    
    class ViewHolder: ViewHolderable {
        private let headerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.backgroundColor = .systemPink
            return stackView
        }()
        
        let containerScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.bounces = false
            return scrollView
        }()
        
        let tabCollectionView: UICollectionView = {
            let tabSectionLayout = EventHomeSectionLayout().tabLayout()
            let layout = UICollectionViewCompositionalLayout(section: tabSectionLayout)
            let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: layout)
            collectionView.showsHorizontalScrollIndicator = false
            return collectionView
        }()
        
        private let contentView: UIView = {
            let view = UIView()
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
            contentView.addSubview(headerStackView)
            contentView.addSubview(tabCollectionView)
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
            
            headerStackView.snp.makeConstraints {
                $0.height.equalTo(Size.headerViewHeight)
                $0.top.leading.trailing.equalToSuperview()
            }
            
            tabCollectionView.snp.makeConstraints {
                $0.height.equalTo(Size.tabCollectionViewHeight)
                $0.top.equalTo(headerStackView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
            
            contentPageView.snp.makeConstraints {
                $0.top.equalTo(tabCollectionView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }

            pageViewController.view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}

extension EventHomeViewController: EventHomePageViewControllerDelegate {
    
    func updateSelectedTabCell(index: Int) {
        updateSelectedTabCell(with: index)
    }
}

extension EventHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCell.className, for: indexPath) as? TabCell else { return UICollectionViewCell() }
        cell.update(with: tabData[indexPath.row])
        return cell
    }
}

extension EventHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == viewHolder.tabCollectionView {
            updateSelectedTabCell(with: indexPath.row)
            viewHolder.pageViewController.updatePage(indexPath.row)
        }
    }
}
    
    
    
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
            
            let maxOffsetY = max(viewHolder.containerScrollView.contentOffset.y - (innerScrollLastOffsetY - scrollView.contentOffset.y), 0)
            let offsetY = min(maxOffsetY, outerScrollMaxOffset)
            viewHolder.containerScrollView.contentOffset.y = offsetY
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
