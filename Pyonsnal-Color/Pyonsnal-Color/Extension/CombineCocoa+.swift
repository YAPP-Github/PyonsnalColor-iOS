//
//  CombineCocoa+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/06.
//

import UIKit
import Combine

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        return controlPublisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        return controlPublisher(for: .editingChanged)
            .compactMap { $0 as? UITextField }
            .map { $0.text }
            .eraseToAnyPublisher()
    }
}
