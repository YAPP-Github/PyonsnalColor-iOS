//
//  TitleNavigationView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/28.
//

import UIKit
import SnapKit

final class TitleNavigationView: UIView {
    
    enum Constant {
        enum Size {
            static let stackViewMargin: UIEdgeInsets = .init(
                top: 11,
                left: 16,
                bottom: 11,
                right: 16
            )
        }
        
        enum Text {
            static let font: UIFont = .title2
        }
    }
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constant.Size.stackViewMargin
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Text.font
        return label
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        //TODO: 추가될 알림버튼 이미지 적용
        button.setImage(.init(systemName: "bell"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    convenience init(title: String) {
        self.init(frame: .zero)
        
        configureLayout()
        titleLabel.text = title
    }
    
    private func configureLayout() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(notificationButton)
    }
    
    private func configureConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //TODO: 알림버튼에 알림 데이터와 연결 후 데이터 여부에 따라 버튼 이미지 변경
}
