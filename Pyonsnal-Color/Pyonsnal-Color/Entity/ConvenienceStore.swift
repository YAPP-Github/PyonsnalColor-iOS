//
//  ConvenienceStore.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import UIKit

enum ConvenienceStore: String, Decodable, Hashable, CaseIterable {
    case all = "all"
    case cu = "CU"
    case gs25 = "GS25"
    case emart24 = "EMART24"
    case sevenEleven = "SEVEN_ELEVEN"
    
    var storeIconImage: ImageAssetKind.StoreIcon? {
        switch self {
        case .cu:
            return ImageAssetKind.StoreIcon.iconCU
        case .gs25:
            return ImageAssetKind.StoreIcon.iconGS
        case .sevenEleven:
            return ImageAssetKind.StoreIcon.icon7Eleven
        case .emart24:
            return ImageAssetKind.StoreIcon.iconEmart24
        case .all:
            return nil
        }
    }
    
    var storeTagImage: ImageAssetKind.StoreTag? {
        switch self {
        case .cu:
            return ImageAssetKind.StoreTag.storeTagCU
        case .gs25:
            return ImageAssetKind.StoreTag.storeTagGS25
        case .sevenEleven:
            return ImageAssetKind.StoreTag.storeTagSevenEleven
        case .emart24:
            return ImageAssetKind.StoreTag.storeTagEmart24
        case .all:
            return nil
        }
    }
}

extension ConvenienceStore {
    var storeIcon: ImageAssetKind.StoreIcon? {
        switch self {
        case .all:
            return nil
        case .cu:
            return .iconCU
        case .gs25:
            return .iconGS
        case .emart24:
            return .iconEmart24
        case .sevenEleven:
            return .icon7Eleven
        }
    }
}
