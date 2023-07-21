//
//  ProfileHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import UIKit
import ModernRIBs
import SnapKit

protocol ProfileHomePresentableListener: AnyObject {
    func didTapTeams(with settingInfo: SettingInfo) // 만든 사람들
    func didTapAccountSetting() // 계정 설정
}

final class ProfileHomeViewController: UIViewController,
                                       ProfileHomePresentable,
                                       ProfileHomeViewControllable {

    enum Size {
        static let profileImageViewSize: CGFloat = 40
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
    
    //MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private let sections: [Section] = [.setting]
    private let settings = [
        SettingInfo(title: "기타"),
        SettingInfo(title: "버전정보"),
        SettingInfo(title: "만든 사람들"),
        SettingInfo(title: "계정 설정")
    ]
    //MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureTableView()
    }
    
    func update(with member: MemberInfoEntity) {
        viewHolder.nickNameLabel.text = member.nickname
    }
    
    //MARK: - Private Method
    private func configureTableView() {
        viewHolder.tableView.delegate = self
        viewHolder.tableView.dataSource = self
        viewHolder.tableView.register(ProfileCell.self)
    }
    
    private func configureTabBarItem() {
        
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: "MY",
            image: UIImage(named: "profile"),
            selectedImage: UIImage(named: "profile.selected")
        )
    }
}

//MARK: - UITableViewDataSource
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

//MARK: - UITableViewDelegate
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

//MARK: - UI Component
extension ProfileHomeViewController {
    class ViewHolder: ViewHolderable {
        
        private let profileContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        private let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.setImage(.defaultPyonsnalColor)
            return imageView
        }()
        
        let nickNameLabel: UILabel = {
            let label = UILabel()
            label.font = .title2
            label.text = "양볼 빵빵 다람쥐"
            label.textColor = .black
            label.numberOfLines = 1
            return label
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
            profileContainerView.addSubview(nickNameLabel)
            profileContainerView.addSubview(profileImageView)
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
                $0.trailing.greaterThanOrEqualToSuperview().inset(.spacing12)
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
