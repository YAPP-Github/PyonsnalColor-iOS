//
//  NewTagBig.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/06.
//

import UIKit
import SnapKit

final class NewTagBig: UIView {
    // MARK: - Declaration
    enum Constant {
        enum Size {
            static let titleLabelWidth: CGFloat = 46
            static let titleLabelHeight: CGFloat = 24
        }
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.font = .title1
        label.textColor = .red500
        label.text = "NEW"
        return label
    }()
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(titleLabel)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(Constant.Size.titleLabelWidth)
            make.height.equalTo(Constant.Size.titleLabelHeight)
            make.edges.equalToSuperview()
        }
    }
}
