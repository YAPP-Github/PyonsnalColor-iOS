//
//  ProfileCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/27.
//

import UIKit
import SnapKit

final class ProfileCell: UITableViewCell {
    
    enum Size {
        static let sectionTitleLabelTop: CGFloat = 14
        
        static let titleLabelTop: CGFloat = 10
        static let titleLabelBottom: CGFloat = 14
        
        static let subLabelTop: CGFloat = 11
        static let subLabelBottom: CGFloat = 17
        
        static let leadingMargin: CGFloat = 16
        static let dividerHeight: CGFloat = 1
    }
    
    //MARK: - Private Property
    private let viewHolder: ViewHolder = .init()
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(text: String, isSectionIndex: Bool) {
        if isSectionIndex {
            //to do fix color
            viewHolder.titleLabel.textColor = .darkGray
            viewHolder.titleLabel.font = .body3r
            updateSectionTitleLayout()
        }
        viewHolder.titleLabel.text = text
    }
    
    func setSubLabelHidden(isShow: Bool) {
        viewHolder.subLabel.isHidden = !isShow
    }
    
    func setDividerHidden(isShow: Bool) {
        viewHolder.dividerView.isHidden = !isShow
    }
    
    func updateSectionTitleLayout() {
        viewHolder.titleLabel.snp.updateConstraints {
            $0.top.equalToSuperview().offset(Size.sectionTitleLabelTop)
        }
    }
    
    
}

extension ProfileCell {
    //MARK: - UI Component
    class ViewHolder: ViewHolderable {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body2m
            //to do fix color
            label.textColor = .black
            return label
        }()
        
        lazy var subLabel: UILabel = {
            let label = UILabel()
            label.font = .body3r
            //to do fix color
            label.textColor = .darkGray
            label.text = AppInfo.shared.appVersion
            label.isHidden = true
            return label
        }()
        
        let dividerView: UIView = {
            let view = UIView()
            view.isHidden = true
            //to do fix color
            view.backgroundColor = .gray
            return view
        }()
        
        func place(in view: UIView) {
            view.addSubview(titleLabel)
            view.addSubview(subLabel)
            view.addSubview(dividerView)
        }
        
        func configureConstraints(for view: UIView) {
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Size.leadingMargin)
                $0.top.equalToSuperview().offset(Size.titleLabelTop)
                $0.bottom.equalToSuperview().inset(Size.titleLabelBottom)
            }
            
            subLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(Size.subLabelTop)
                $0.trailing.equalToSuperview().inset(Size.leadingMargin)
                $0.bottom.equalToSuperview().inset(Size.subLabelBottom)
            }
            
            dividerView.snp.makeConstraints {
                $0.height.equalTo(Size.dividerHeight)
                $0.leading.equalToSuperview().offset(Size.leadingMargin)
                $0.trailing.equalToSuperview().inset(Size.leadingMargin)
                $0.bottom.equalToSuperview()
            }
        }
    }
}
