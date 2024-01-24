//
//  FoodChemistryEventView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/23/24.
//

import UIKit
import SnapKit

final class FoodChemistryEventView: UIView {
    private let links: [String]
    
    let foodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    init(links: [String]) {
        self.links = links
        super.init(frame: .zero)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        foodCollectionView.collectionViewLayout = createCollectionViewLayout()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 68
        layout.minimumInteritemSpacing = 14
        layout.itemSize = CGSize(width: 110, height: 110)
        layout.sectionInset = UIEdgeInsets(top: 0, left: .spacing16, bottom: 0, right: .spacing16)
        
        return layout
    }
}

extension FoodChemistryEventView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return links.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        <#code#>
    }
}
