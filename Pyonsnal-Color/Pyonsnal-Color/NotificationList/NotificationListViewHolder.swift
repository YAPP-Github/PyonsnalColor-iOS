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
                static let stackViewMargin: UIEdgeInsets = .init(
                    top: 16,
                    left: 16,
                    bottom: 16,
                    right: 16
                )
            }
            
            enum Text {
                static let color: UIColor = .systemGray3
                static let font: UIFont = .body3r
            }
        }
        
        private let contentView: UIView = .init()
        
        let emptyNotificationLabel: UILabel = {
            let label = UILabel()
            label.text = "아직 받은 알림이 없어요."
            label.textColor = Constant.Text.color
            label.font = Constant.Text.font
            return label
        }()
        
        let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = Constant.Size.spacing
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = Constant.Size.stackViewMargin
            return stackView
        }()
        
        let notificationsTableView: UITableView = {
            let tableView = UITableView()
            return tableView
        }()
        
        let principleLabel: UILabel = {
            let label = UILabel()
            label.text = "최근 30일 동안의 알림만 확인 가능해요."
            label.textColor = Constant.Text.color
            label.font = Constant.Text.font
            return label
        }()
        
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(emptyNotificationLabel)
            contentView.addSubview(containerStackView)
            
            containerStackView.addArrangedSubview(notificationsTableView)
            containerStackView.addArrangedSubview(principleLabel)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            containerStackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            notificationsTableView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
            }
            
            principleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.greaterThanOrEqualToSuperview()
            }
        }
    }
}
