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

extension UIView {
    func gesturePublisher(with delegate: UIGestureRecognizerDelegate? = nil) -> GesturePublisher {
        /// 현재는 tapGesture가 default. 추후 다른 gesture가 필요로 되면 gestureRecognizer 확장하여 사용.
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.delegate = delegate
        return GesturePublisher(targetView: self, gestureRecognizer: gestureRecognizer)
    }
}
