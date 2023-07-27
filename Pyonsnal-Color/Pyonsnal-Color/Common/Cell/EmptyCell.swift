//
//  EmptyCell.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/24.
//

import UIKit
import SnapKit

final class EmptyCell: UICollectionViewCell {
    
    // MARK: - Declaration
    enum Text {
        static let titleLabelText = "앗! 원하는 검색 결과가 없어요."
        static let subtitleLabelText = "단어의 철자가 올바른지 한 번 더 확인해주세요."
    }
    
    // MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        configureConstraint()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func configureView() {
        viewHolder.place(in: contentView)
    }
    
    private func configureConstraint() {
        viewHolder.configureConstraints(for: contentView)
    }
    
    private func configureUI() {
        viewHolder.titleLabel.text = Text.titleLabelText
        viewHolder.subtitleLabel.text = Text.subtitleLabelText
    }
}
