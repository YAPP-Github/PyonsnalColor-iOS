//
//  BackNavigationView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/01.
//

import UIKit
import SnapKit

final class BackNavigationView: UIView {
    // MARK: - Declaration
    struct Payload {
        var mode: TitleMode = .image
        var title: String?
        var iconImageKind: ImageAssetKind.StoreIcon?
    }
    
    enum TitleMode {
        case text
        case image
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    
    private let backButton: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.setImage(.iconBack, for: .normal)
        return button
    }()
    
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = .init(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.textColor = .black
        return label
    }()
    
    // MARK: - Interface
    weak var delegate: BackNavigationViewDelegate?
    
    // MARK: - Private Property
    var payload: Payload? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        configureView(with: payload?.mode ?? .image)
        configureConstraint()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(with text: String) {
        titleLabel.text = text
    }
    
    // MARK: - Private Method
    @objc private func backButtonAction(_ sender: UIButton) {
        delegate?.didTapBackButton()
    }
    
    private func updateUI() {
        guard let payload else { return }
        if let iconImageKind = payload.iconImageKind {
            iconImageView.setImage(iconImageKind)
        }
        titleLabel.text = payload.title
        setContentViewToHidden(with: payload.mode)
    }
    
    private func configureUI() {
        backButton.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
    }
    
    private func configureView(with mode: TitleMode) {
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(backButton)
        setContentViewToHidden(with: mode)
        
    }
    
    private func setContentViewToHidden(with mode: TitleMode) {
        setInitContentView()
        if mode == .text {
            titleLabel.isHidden = false
        } else if mode == .image {
            iconImageView.isHidden = false
        }
    }
    
    private func setInitContentView() {
        iconImageView.isHidden = true
        titleLabel.isHidden = true
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.equalToSuperview().offset(.spacing16)
            make.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
