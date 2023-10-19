//
//  ReviewFeedbackButtonView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/10/03.
//

import UIKit
import SnapKit

final class ReviewFeedbackButtonView: UIButton {
    
    // MARK: - Declaration
    
    struct Payload {
        let feedbackKind: ReviewFeedKind
        let isSelected: Bool
        let count: Int
    }
    
    enum Size {
        static let borderWidth: CGFloat = 1
    }
    
    // MARK: - UI Component
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray400
        label.font = .body3m
        return label
    }()
    
    // MARK: - Interface
    
    var payload: Payload? { didSet { updateUI() } }
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    private func configureUI() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(countLabel)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(.spacing16)
            make.top.bottom.equalToSuperview().inset(5)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        countLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        makeRounded(with: 15)
        makeBorder(
            width: Size.borderWidth,
            color: UIColor.gray200.cgColor
        )
    }

    private func updateUI() {
        guard let payload else { return }
        
        switch payload.feedbackKind {
        case .good:
            if isSelected {
                iconImageView.setImage(.iconThumbsUpUnfilled)
            } else {
                iconImageView.setImage(.iconThumbsUpUnfilled)
            }
        case .bad:
            if isSelected {
                iconImageView.setImage(.iconThumbsDownUnfilled)
            } else {
                iconImageView.setImage(.iconThumbsDownUnfilled)
            }
        }
        
        if payload.count == 0 {
            countLabel.isHidden = true
        } else {
            countLabel.isHidden = false
            countLabel.text = "\(payload.count)"
            countLabel.adjustsFontSizeToFitWidth = true
        }
    }
}
