//
//  NotificationListViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/27.
//

import ModernRIBs
import UIKit

protocol NotificationListPresentableListener: AnyObject {
    func didTabBackButton()
}

// TODO: 나중에 Entity폴더로 이동
struct NotificationEntity: Hashable {
    enum Category: Hashable {
        case product
        case event
        case keyword(text: String)
    }
    
    let category: Category
    let description: String
    let date: String
    var isRead: Bool
    var keyword: String?
    var image: UIImage? {
        switch category {
        case .product:
            return ImageAssetKind.productTag.image
        case .event:
            return ImageAssetKind.eventTag.image
        case .keyword(_):
            return ImageAssetKind.keywordTag.image
        }
    }
}

final class NotificationListViewController:
    UIViewController,
    NotificationListPresentable,
    NotificationListViewControllable {
    
    weak var listener: NotificationListPresentableListener?
    
    //MARK: - Property
    private let viewHolder: ViewHolder = .init()
    private var notifications: [NotificationEntity] = []
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureDummyData()
        configureTableView()
        configureBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTableViewOrLabel()
    }
    
    //MARK: - Private Method
    private func configureDummyData() {
        notifications = [
            NotificationEntity(
                category: .product,
                description: "새로운 상품이 업데이트되었어요💕",
                date: DateFormatter.notificationFormatter.string(from: Date()),
                isRead: true
            ),
                
            NotificationEntity(
                category: .product,
                description: "새로운 상품이 업데이트되었어용💕",
                date: DateFormatter.notificationFormatter.string(from: Date()),
                isRead: true
            ),
            NotificationEntity(
                category: .event,
                description: "새로운 행사가 시작되었어요🎁",
                date: DateFormatter.notificationFormatter.string(from: Date()),
                isRead: true
            ),
            NotificationEntity(
                category: .keyword(text: "매운"),
                description: "[매운] '농심)매운새우깡90g'의 행사가 업데이트 되었어요🎁",
                date: DateFormatter.notificationFormatter.string(from: Date()),
                isRead: true
            )
        ]
    }
    
    private func configureTableView() {
        viewHolder.notificationsTableView.dataSource = self
        viewHolder.notificationsTableView.delegate = self
        viewHolder.notificationsTableView.tableFooterView = viewHolder.footerView
        viewHolder.notificationsTableView.register(
            NotificationCell.self,
            forCellReuseIdentifier: NotificationCell.identifier
        )
    }
    
    private func configureBackButton() {
        viewHolder.backButton.addTarget(
            self,
            action: #selector(didTabBackButton),
            for: .touchUpInside
        )
    }
    
    private func hideTableViewOrLabel() {
        if notifications.isEmpty {
            viewHolder.notificationsTableView.isHidden = true
        } else {
            viewHolder.emptyNotificationLabel.isHidden = true
        }
    }
    
    @objc
    private func didTabBackButton() {
        listener?.didTabBackButton()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension NotificationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.identifier,
            for: indexPath
        ) as? NotificationCell else {
            return UITableViewCell()
        }

        cell.updateCell(with: notifications[indexPath.row])
         
        return cell
    }
}
