//
//  AccountSettingViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/28.
//

import ModernRIBs
import UIKit

protocol AccountSettingPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapDeleteAccountButton()
    func didTapLogoutButton()
}

final class AccountSettingViewController: UIViewController,
                                          AccountSettingPresentable,
                                          AccountSettingViewControllable {
    enum Size {
        static let backButtonSize: CGFloat = 24
        static let secessionButtonBottom: CGFloat = 34
        static let cellHeight: CGFloat = 48
        static let rows: CGFloat = 2
        static var cellTotalHeight: CGFloat {
            return rows * cellHeight
        }
    }
    
    enum Index {
        static let logout: Int = 1
    }
    
    weak var listener: AccountSettingPresentableListener?
    
    //MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    private let accountSettingData = ["서비스 이용 약관", "로그아웃"]
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureTableView()
        configureAction()
    }
    
    //MARK: - Private Method
    private func configureTableView() {
        viewHolder.tableView.delegate = self
        viewHolder.tableView.dataSource = self
        viewHolder.tableView.register(ProfileCell.self)
    }
    
    private func configureAction() {
        viewHolder.backButton.addTarget(
            self,
            action: #selector(didTapBackButton),
            for: .touchUpInside
        )
        viewHolder.deleteAccount.addTarget(
            self,
            action: #selector(didTapDeleteAccountButton),
            for: .touchUpInside
        )
    }
    
    @objc
    private func didTapBackButton() {
        listener?.didTapBackButton()
    }
    
    @objc
    private func didTapDeleteAccountButton() {
        listener?.didTapDeleteAccountButton()
    }
}

extension AccountSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == Index.logout {
            listener?.didTapLogoutButton()
        }
    }
}

extension AccountSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSettingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileCell = tableView.dequeueReusableCell(for: indexPath)
        let text = accountSettingData[indexPath.row]
        cell.update(text: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.cellHeight
    }
    
    
}

//MARK: - UI Component
extension AccountSettingViewController {
    class ViewHolder: ViewHolderable {
        let headerView: UIView = { // TO DO : 커스텀 뷰로 변경 예정
            let view = UIView()
            return view
        }()
        
        let backButton: UIButton = {
            let button = UIButton()
            button.setImage(.actions, for: .normal) // 임시
            return button
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "계정 설정"
            label.font = .title2
            return label
        }()
        
        let tableView: UITableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
            tableView.bounces = false
            return tableView
        }()
        
        let deleteAccount: UIButton = {
            let button = UIButton()
            button.addUnderLine(with: "회원 탈퇴",
                                color: .gray500,
                                font: .body2m)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(headerView)
            headerView.addSubview(backButton)
            headerView.addSubview(titleLabel)
            view.addSubview(tableView)
            
            view.addSubview(deleteAccount)
        }
        
        func configureConstraints(for view: UIView) {
            headerView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(50) // 임의
            }
            
            backButton.snp.makeConstraints {
                $0.size.equalTo(Size.backButtonSize)
                $0.leading.equalToSuperview().offset(16)
                $0.centerY.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(AccountSettingViewController.Size.cellTotalHeight)
            }
            
            deleteAccount.snp.makeConstraints {
                $0.leading.equalTo(16)
                $0.bottom.equalToSuperview().inset(Size.secessionButtonBottom)
            }
        }
        

    }
}
