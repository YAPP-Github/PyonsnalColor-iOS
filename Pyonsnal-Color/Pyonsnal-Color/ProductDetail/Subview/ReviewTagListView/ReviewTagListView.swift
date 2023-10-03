//
//  ReviewTagListView.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/29.
//

import UIKit
import SnapKit

final class ReviewTagListView: UIView {
    
    // MARK: - Declaration
    
    struct Payload {
        let taste: ReviewEvaluationState
        let quality: ReviewEvaluationState
        let valueForMoney: ReviewEvaluationState
    }
    
    // MARK: - UI Component
    
    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    private let stackView: UIStackView = {
        let stackView: UIStackView = .init(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Interface
    
    var payload: Payload? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Initialier
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    
    private func configureUI() {
        addSubview(contentView)
        
        contentView.addSubview(stackView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateUI() {
        guard let payload else { return }
        
        let estimatetSize = CGSize(width: 110, height: 28)
        var currentWidth: CGFloat = 0
        
        stackView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        let estimateSize = CGSize(width: 50, height: 30)
        let line1StackView = UIStackView()
        line1StackView.axis = .horizontal
        line1StackView.spacing = 8
        
        let tasteLabel = ReviewEvaluationLabel()
        tasteLabel.payload = .init(kind: .taste, state: payload.taste)
        tasteLabel.frame = .init(origin: .zero, size: estimateSize)
        tasteLabel.layoutIfNeeded()
        tasteLabel.systemLayoutSizeFitting(estimateSize)
        
        currentWidth += tasteLabel.bounds.width
        currentWidth += 8
        line1StackView.addArrangedSubview(tasteLabel)
        
        let qualityLabel = ReviewEvaluationLabel()
        qualityLabel.payload = .init(kind: .quality, state: payload.quality)
        qualityLabel.layoutIfNeeded()
        qualityLabel.systemLayoutSizeFitting(estimatetSize)
        currentWidth += qualityLabel.bounds.width
        currentWidth += 8
        line1StackView.addArrangedSubview(qualityLabel)
        
        let valueForMoneyLabel = ReviewEvaluationLabel()
        valueForMoneyLabel.payload = .init(kind: .valueForMoney, state: payload.valueForMoney)
        valueForMoneyLabel.layoutIfNeeded()
        valueForMoneyLabel.systemLayoutSizeFitting(estimatetSize)
        if false {//currentWidth + valueForMoneyLabel.bounds.width > bounds.width {
            let line2StackView = UIStackView()
            line2StackView.axis = .horizontal
            line2StackView.spacing = 8
            
            line2StackView.addArrangedSubview(valueForMoneyLabel)
            
            stackView.addArrangedSubview(line1StackView)
            stackView.addArrangedSubview(line2StackView)
        } else {
            line1StackView.addArrangedSubview(valueForMoneyLabel)
            stackView.addArrangedSubview(line1StackView)
        }
        
    }
}
