//
//  NSObject+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/23.
//

import Foundation

protocol ClassNameRenderable {
    static var className: String { get }
}

extension ClassNameRenderable {
    static var className: String {
        return String(describing: self)
    }
}

extension NSObject: ClassNameRenderable {}
