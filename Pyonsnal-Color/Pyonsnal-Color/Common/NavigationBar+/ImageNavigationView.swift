//
//  ImageNavigationView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/01.
//

import UIKit
import SnapKit

final class ImageNavigationView: UIView {
    // MARK: - Declaration
    struct Payload {
        let iconImageKind: ImageAssetKind.Icon
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    private let backButton: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.backgroundColor = .cyan
        return button
    }()
    
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = .init(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Interface
    weak var delegate: ImageNavigationViewDelegate?
    
    // MARK: - Private Property
    private let payload: Payload
    
    // MARK: - Initializer
    init(payload: Payload) {
        self.payload = payload
        
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    @objc private func backButtonAction(_ sender: UIButton) {
        delegate?.didTapBackButton()
    }
    
    private func configureUI() {
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        
        iconImageView.setImage(payload.iconImageKind)
    }
    
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(backButton)
        contentView.addSubview(iconImageView)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalToSuperview().offset(.spacing8)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
    }
}
