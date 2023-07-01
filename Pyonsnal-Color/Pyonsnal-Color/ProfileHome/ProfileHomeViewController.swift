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
    func didTapAccountSetting() //계정 설정
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
        case notification
        case setting
    }
    
    weak var listener: ProfileHomePresentableListener?
    
    //MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private let sectionData: [Section] = [.notification, .setting]
    private let alarmData = ["알림 설정", "전체 알림", "키워드 알림"]
    private let settingData = ["기타", "이메일로 문의하기", "버전정보", "만든 사람들", "계정 설정"]
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
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureTableView()
    }
    
    //MARK: - Private Method
    private func configureTableView() {
        viewHolder.tableView.delegate = self
        viewHolder.tableView.dataSource = self
        viewHolder.tableView.register(ProfileCell.self)
    }
    
    private func configureTabBarItem() {
        let customFont: UIFont = .label2
        
        tabBarItem.setTitleTextAttributes([.font: customFont], for: .normal)
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
    
    private func isDividerToShow(section: Section, index: Int) -> Bool {
        return (section == .notification) && (index == alarmData.count - 1)
    }
    
    private func isSubLabelToShow(section: Section, index: Int) -> Bool {
        let versionInfoIndex = 2
        return (section == .setting) && (index == versionInfoIndex)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sectionData[section]
        switch section {
        case .notification:
            return alarmData.count
        case .setting:
            return settingData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = tableView.dequeueReusableCell(for: indexPath)
        
        let section = sectionData[indexPath.section]
        let isSectionIndex = isSectionIndex(with: indexPath.row)
        let isDividerToShow = isDividerToShow(section: section, index: indexPath.row)
        let isSubLabelToShow = isSubLabelToShow(section: section, index: indexPath.row)
        switch section {
        case .notification:
            cell.update(text: alarmData[indexPath.row],
                             isSectionIndex: isSectionIndex)
        case .setting:
            cell.update(text: settingData[indexPath.row],
                             isSectionIndex: isSectionIndex)
        }
        cell.setDividerHidden(isShow: isDividerToShow)
        cell.setSubLabelHidden(isShow: isSubLabelToShow)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ProfileHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sectionData[indexPath.section]
        let defaultHeight = Size.cellHeight
        if isDividerToShow(section: section, index: indexPath.row) {
            return defaultHeight + Size.dividerHeight
        }
        return defaultHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sectionData[indexPath.section]
        let accountSettingIndex = 4
        if !isSectionIndex(with: indexPath.row) {
            switch section {
            case .notification:
                print(alarmData[indexPath.row])
            case .setting:
                if indexPath.row == accountSettingIndex {
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
            // to do fix color
            view.backgroundColor = .white
            return view
        }()
        
        private let profileImageContainerView: UIView = {
            let view = UIView()
            // to do fix color
            view.backgroundColor = .white
            view.makeRounded(with: Size.profileImageViewSize / 2)
            view.makeBorder(width: 1, color: UIColor.black.cgColor)
            return view
        }()
        
        private let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.setImage(.default_profile)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let nickNameLabel: UILabel = {
            let label = UILabel()
            label.font = .title2
            label.text = "양볼 빵빵 다람쥐"
            // to do fix color
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
            // to do fix color
            view.backgroundColor = .gray
            return view
        }()
        
        func place(in view: UIView) {
            view.addSubview(profileContainerView)
            profileContainerView.addSubview(profileImageContainerView)
            profileImageContainerView.addSubview(profileImageView)
            profileContainerView.addSubview(nickNameLabel)
            view.addSubview(dividerView)
            view.addSubview(tableView)
        }
        
        func configureConstraints(for view: UIView) {
            profileContainerView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(Size.profileContainerViewHeight)
            }
            
            profileImageContainerView.snp.makeConstraints {
                $0.size.equalTo(Size.profileImageViewSize)
                $0.leading.equalToSuperview().offset(Size.profileImageViewLeading)
                $0.centerY.equalToSuperview()
            }
            
            // to do fix using common margin
            profileImageView.snp.makeConstraints {
                $0.leading.top.equalToSuperview().offset(8)
                $0.trailing.bottom.equalToSuperview().offset(-8)
            }
            
            nickNameLabel.snp.makeConstraints {
                $0.leading.equalTo(profileImageContainerView.snp.trailing).offset(12)
                $0.centerY.equalTo(profileContainerView.snp.centerY)
                $0.trailing.greaterThanOrEqualTo(-12)
            }
            
            dividerView.snp.makeConstraints {
                $0.top.equalTo(profileContainerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(12)
            }
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(dividerView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            
        }
    }
}
