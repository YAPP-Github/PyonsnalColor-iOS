//
//  DateFormatter+.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/30.
//

import Foundation

extension DateFormatter {
    static let notificationFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.mm.dd"
        return dateFormatter
    }()
    
    static let productLastUpdateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.mm.dd"
        return dateFormatter
    }()
}
