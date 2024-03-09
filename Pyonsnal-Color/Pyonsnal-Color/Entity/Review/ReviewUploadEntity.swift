//
//  ReviewUploadEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/10/09.
//

import Foundation

struct ReviewUploadEntity: Encodable {
    let taste: String
    let quality: String
    let valueForMoney: String
    let score: Double
    let contents: String
    let writerId: Int
    let writerName: String
}
