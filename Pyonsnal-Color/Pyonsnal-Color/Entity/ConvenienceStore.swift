//
//  ConvenienceStore.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import Foundation

enum ConvenienceStore: String, Decodable, Hashable, CaseIterable {
    case all = "all"
    case cu = "CU"
    case gs25 = "GS25"
    case emart24 = "EMART24"
    case sevenEleven = "SEVEN_ELEVEN"
}
