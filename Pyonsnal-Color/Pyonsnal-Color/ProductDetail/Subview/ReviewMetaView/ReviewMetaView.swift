//
//  ReviewMetaView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/17.
//

import UIKit

final class ReviewMetaView: UIView {
    // MARK: - Declaration
    struct Payload {
    }
    
    // MARK: - UI Component
    private let contentView: UIView = {
        let view: UIView = .init(frame: .zero)
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .body3m
        label.textColor = .black
        return label
    }()
    
    let ratingPreviewView: RatingPreviewView = {
        let view = RatingPreviewView()
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .gray400
        label.font = .body3r
        return label
    }()
    
    
    // MARK: - Interface
    var payload: Payload? {
        didSet {
            updateUI()
        }
    }
    
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
    private func updateUI() {
        iconImageView.setImage(.iconReview)
        
        guard let payload else {
            return
        }
        
        countLabel.text = "\(payload.ratingCount)"
    }
    
    private func configureView() {
        addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingPreviewView)
        contentView.addSubview(dateLabel)
    }
    
    private func configureConstraint() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing)
        }
        
        ratingPreviewView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(.spacing2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(.spacing8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(.spacing8)
            make.trailing.equalToSuperview()
        }
    }
}
