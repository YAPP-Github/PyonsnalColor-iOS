//
//  UIControl+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/06.
//

import UIKit
import Combine

extension UIControl {
    func controlPublisher(for event: UIControl.Event) -> ControlPublisher {
        return ControlPublisher(control: self, controlEvent: event)
    }
}
