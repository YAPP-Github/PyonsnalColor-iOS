//
//  ProductConvertable.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import UIKit

protocol ProductConvertable: Decodable {
    var imageURL: URL { get }
    var storeType: ConvenienceStore { get }
    var updatedTime: String { get }
    var name: String { get }
    var price: String { get }
    var description: String { get }
}

extension ProductConvertable {
    var storeTagImage: UIImage? {
        switch storeType {
        case .cu:
            return ImageAssetKind.StoreTag.storeTagCU.image
        case .gs25:
            return ImageAssetKind.StoreTag.storeTagGS25.image
        case .sevenEleven:
            return ImageAssetKind.StoreTag.storeTagSevenEleven.image
        case .emart24:
            return ImageAssetKind.StoreTag.storeTagEmart24.image
        case .all:
            return nil
        }
    }
}
 
