//
//  ConvenienceStore.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import UIKit

enum ConvenienceStore: String, Decodable, Hashable, CaseIterable {
    case cu = "CU"
    case gs25 = "GS25"
    case emart24 = "EMART24"
    case sevenEleven = "SEVEN_ELEVEN"
    
    var storeIconImage: ImageAssetKind.StoreIcon? {
        switch self {
        case .cu:
            return ImageAssetKind.StoreIcon.cu
        case .gs25:
            return ImageAssetKind.StoreIcon.gs25
        case .sevenEleven:
            return ImageAssetKind.StoreIcon.sevenEleven
        case .emart24:
            return ImageAssetKind.StoreIcon.emart24
        }
    }
    
    var storeTagImage: ImageAssetKind.StoreTag? {
        switch self {
        case .cu:
            return ImageAssetKind.StoreTag.cu
        case .gs25:
            return ImageAssetKind.StoreTag.gs25
        case .sevenEleven:
            return ImageAssetKind.StoreTag.sevenEleven
        case .emart24:
            return ImageAssetKind.StoreTag.emart24
        }
    }
    
    var convenienceStoreCellName: String {
        switch self {
        case .cu:
            return "CU"
        case .gs25:
            return "GS25"
        case .emart24:
            return "Emart24"
        case .sevenEleven:
            return "7-Eleven"
        }
    }
}

extension ConvenienceStore {
    var storeIcon: ImageAssetKind.StoreIcon? {
        switch self {
        case .cu:
            return .cu
        case .gs25:
            return .gs25
        case .emart24:
            return .emart24
        case .sevenEleven:
            return .sevenEleven
        }
    }
}
