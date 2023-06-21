//
//  Reusable.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/21.
//

import Foundation

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}
