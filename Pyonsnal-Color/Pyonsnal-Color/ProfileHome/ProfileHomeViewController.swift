//
//  ProfileHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import UIKit
import Combine
import ModernRIBs
import SnapKit

protocol ProfileHomePresentableListener: AnyObject {
    func didTapProfileEditButton(memberInfo: MemberInfoEntity) // 프로파일 편집
    func didTapTeams(with settingInfo: SettingInfo) // 만든 사람들
    func didTapAccountSetting() // 계정 설정
}

final class ProfileHomeViewController: UIViewController,
                                       ProfileHomePresentable,
                                       ProfileHomeViewControllable {

    enum Size {
        static let profileImageViewSize: CGFloat = 40
        static let profileEditButtonSize: CGFloat = 48
        static let profileImageViewLeading: CGFloat = 17
        static let profileContainerViewHeight: CGFloat = 104
        
        static let dividerMargin: CGFloat = 12
        static let cellHeight: CGFloat = 48
        static let dividerHeight: CGFloat = 1
    }
    
    enum Section: String {
        case setting
    }
    
    weak var listener: ProfileHomePresentableListener?
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private var cancellable = Set<AnyCancellable>()
    private var memberInfo: MemberInfoEntity?
    private let sections: [Section] = [.setting]
    private let settings = [
        SettingInfo(title: "기타"),
        SettingInfo(title: "버전정보"),
        SettingInfo(title: "만든 사람들"),
        SettingInfo(title: "계정 설정")
    ]
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureTableView()
        bindActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logging(.pageView, parameter: [
            .screenName: "main_my"
        ])
    }
    
    func update(with memberInfo: MemberInfoEntity) {
        self.memberInfo = memberInfo
        if let profileImage = memberInfo.profileImage,
            let url = URL(string: profileImage) {
            viewHolder.profileImageView.setImage(with: url)
        }
        viewHolder.nickNameLabel.text = memberInfo.nickname
    }
    
    // MARK: - Private Method
    private func configureTableView() {
        viewHolder.tableView.delegate = self
        viewHolder.tableView.dataSource = self
        viewHolder.tableView.register(ProfileCell.self)
    }
    
    private func bindActions() {
        viewHolder.profileEditButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self, let memberInfo else { return }
                self.listener?.didTapProfileEditButton(memberInfo: memberInfo)
            }.store(in: &cancellable)
    }
    
    private func configureTabBarItem() {
        
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: "마이페이지",
            image: ImageAssetKind.TabBar.myUnselected.image,
            selectedImage: ImageAssetKind.TabBar.mySelected.image
        )
    }
}

// MARK: - UITableViewDataSource
extension ProfileHomeViewController: UITableViewDataSource {
    private func isSectionIndex(with index: Int) -> Bool {
        return index == 0
    }
    
    private func isSubLabelToShow(section: Section, index: Int) -> Bool {
        let versionInfoIndex = 1
        return (section == .setting) && (index == versionInfoIndex)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .setting:
            return settings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = tableView.dequeueReusableCell(for: indexPath)
        
        let section = sections[indexPath.section]
        let isSectionIndex = isSectionIndex(with: indexPath.row)
        let isSubLabelToShow = isSubLabelToShow(section: section, index: indexPath.row)
        switch section {
        case .setting:
            cell.update(text: settings[indexPath.row].title,
                        isSectionIndex: isSectionIndex)
        }
        cell.setSubLabelHidden(isShow: isSubLabelToShow)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let defaultHeight = Size.cellHeight
        return defaultHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let teamsIndex = 2
        let accountSettingIndex = 3
        if !isSectionIndex(with: indexPath.row) {
            switch section {
            case .setting:
                if indexPath.row == teamsIndex {
                    let title = settings[indexPath.row].title
                    let settingInfo = SettingInfo(title: title, infoUrl: .teams)
                    listener?.didTapTeams(with: settingInfo)
                } else if indexPath.row == accountSettingIndex {
                    listener?.didTapAccountSetting()
                }
                
            }
        }
    }
}

// MARK: - UI Component
extension ProfileHomeViewController {
    class ViewHolder: ViewHolderable {
        
        private let profileContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.makeRounded(with: Size.profileImageViewSize / 2)
            imageView.setImage(.tagStore)
            return imageView
        }()
        
        let nickNameLabel: UILabel = {
            let label = UILabel()
            label.font = .title2
            label.textColor = .black
            label.numberOfLines = 1
            return label
        }()
        
        let profileEditButton: UIButton = {
            let button = UIButton()
            button.setImage(ImageAssetKind.Profile.profileEdit.image, for: .normal)
            return button
        }()
        
        let tableView: UITableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
            tableView.bounces = false
            return tableView
        }()
        
        private let dividerView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray100
            return view
        }()
        
        func place(in view: UIView) {
            view.addSubview(profileContainerView)
            profileContainerView.addSubview(profileImageView)
            profileContainerView.addSubview(nickNameLabel)
            profileContainerView.addSubview(profileEditButton)
            view.addSubview(dividerView)
            view.addSubview(tableView)
        }
        
        func configureConstraints(for view: UIView) {
            profileContainerView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(Size.profileContainerViewHeight)
            }
            
            profileImageView.snp.makeConstraints {
                $0.size.equalTo(Size.profileImageViewSize)
                $0.leading.equalToSuperview().offset(Size.profileImageViewLeading)
                $0.centerY.equalToSuperview()
            }
            
            nickNameLabel.snp.makeConstraints {
                $0.leading.equalTo(profileImageView.snp.trailing).offset(.spacing12)
                $0.centerY.equalTo(profileContainerView.snp.centerY)
                $0.trailing.greaterThanOrEqualTo(profileEditButton.snp.leading).inset(.spacing12)
            }
            
            profileEditButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(.spacing28)
                $0.trailing.equalToSuperview().inset(.spacing4)
                $0.size.equalTo(Size.profileEditButtonSize)
            }
            
            dividerView.snp.makeConstraints {
                $0.top.equalTo(profileContainerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(Size.dividerMargin)
            }
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(dividerView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            
        }
    }
}
