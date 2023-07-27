//
//  CurationImageCell.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/24.
//

import UIKit
import SnapKit

final class CurationImageCell: UICollectionViewCell {
    enum Size {
        static let imageSize: CGSize = .init(width: 390, height: 240)
    }
    
    private let introductionImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .black
        return imageView
    }()
    
    // TODO: 임시 레이블 삭제
    private let label: UILabel = {
        let label = UILabel()
        label.text = "편스널컬러 소개 이미지"
        label.font = .body3r
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(introductionImageView)
        introductionImageView.addSubview(label)
        
        introductionImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func configureCell(with image: UIImage) {
        introductionImageView.image = image
    }
}
