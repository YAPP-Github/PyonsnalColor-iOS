//
//  NotificationListViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/27.
//

import UIKit
import SnapKit

extension NotificationListViewController {
    final class ViewHolder: ViewHolderable {
        enum Constant {
            enum Size {
                static let spacing: CGFloat = 12
                static let margin: CGFloat = 16
                static let footerSize: CGRect = .init(x: 0, y: 0, width: 240, height: 60)
                static let cellHeight: CGFloat = 110
            }
            
            enum Text {
                static let color: UIColor = .systemGray
                static let font: UIFont = .body3r
            }
        }
        
        private let contentView: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGray6
            return view
        }()
        
        // TODO: 커스텀 네비게이션바로 변경 (임시 네비바)
        let navigationView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let backButton: UIButton = {
            let button = UIButton()
            button.setImage(.init(systemName: "chevron.left"), for: .normal)
            button.tintColor = .black
            return button
        }()
        
        let navigationTitleLabel: UILabel = {
            let label = UILabel()
            label.text = "알림"
            label.font = .title2
            return label
        }()
        
        let emptyNotificationLabel: UILabel = {
            let label = UILabel()
            label.text = "아직 받은 알림이 없어요."
            label.textColor = Constant.Text.color
            label.font = Constant.Text.font
            return label
        }()
        
        let notificationsTableView: UITableView = {
            let tableView = UITableView()
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = Constant.Size.cellHeight
            tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            return tableView
        }()
        
        let footerView: UIView = .init(frame: Constant.Size.footerSize)
        
        let principleLabel: UILabel = {
            let label = UILabel()
            label.text = "최근 30일 동안의 알림만 확인 가능해요."
            label.font =  Constant.Text.font
            label.textColor = Constant.Text.color
            return label
        }()
        
        func place(in view: UIView) {
            view.addSubview(contentView)
            view.addSubview(navigationView)
            
            navigationView.addSubview(backButton)
            navigationView.addSubview(navigationTitleLabel)
            
            contentView.addSubview(navigationView)
            contentView.addSubview(emptyNotificationLabel)
            contentView.addSubview(notificationsTableView)
            
            footerView.addSubview(principleLabel)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalTo(view)
            }
            
            // TODO: 커스텀 네비바 적용
            navigationView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(48)
            }
            
            backButton.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
            }
            
            navigationTitleLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            
            emptyNotificationLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            
            notificationsTableView.snp.makeConstraints { make in
                make.top.equalTo(navigationView.snp.bottom).offset(Constant.Size.margin)
                make.bottom.equalTo(view.safeAreaLayoutGuide)
                make.leading.equalToSuperview().offset(Constant.Size.margin)
                make.trailing.equalToSuperview().inset(Constant.Size.margin)
            }
            
            principleLabel.snp.makeConstraints { make in
                make.centerY.centerX.equalToSuperview()
            }
        }
    }
}
